local AddOnName, AddOn = ...
local L = AddOn.L
local DB = AddOn.DB

local checkFrame = CreateFrame("Frame")
checkFrame:Hide()

local checks = {}
---@param button table
local function addCheck(button)
    checks[button] = true
    checkFrame:Show()
end

local buttons = {}
local fontStrings = {}
local LSM = LibStub("LibSharedMedia-3.0")
---@param button table
local function updateText(button)
    if button then
        local fontString = fontStrings[button]
        fontString:SetDrawLayer(
            DB:Get("visibility", "mouseOver") and "HIGHLIGHT" or "OVERLAY")
        fontString:ClearAllPoints()
        fontString:SetPoint(DB:Get("position", "point"),
                            DB:Get("position", "ofsx"), DB:Get("position", "ofsy"))
        fontString:SetScale(DB:Get("appearance", "scale"))
        fontString:SetFont(LSM:Fetch(LSM.MediaType.FONT,
                                     DB:Get("appearance", "font")),
                           DB:Get("appearance", "height"),
                           DB:Get("appearance", "outline") and "OUTLINE" or "")
        fontString:SetTextColor(DB:Get("appearance", "color", "r"),
                                DB:Get("appearance", "color", "g"),
                                DB:Get("appearance", "color", "b"),
                                DB:Get("appearance", "color", "a"))
        if DB:Get("appearance", "shadow") then
            fontString:SetShadowOffset(1, -1)
        else
            fontString:SetShadowOffset(0, 0)
        end
    else
        for i = 1, #buttons do updateText(buttons[i]) end
    end
end

local UnitPower = UnitPower
local power = setmetatable({}, {
    __index = function(t, k)
        local power = UnitPower("player", k)
        t[k] = power
        return power
    end
})
local UnitPowerMax = UnitPowerMax
local maxPower = setmetatable({}, {
    __index = function(t, k)
        local maxpower = UnitPowerMax("player", k)
        t[k] = maxpower
        return maxpower
    end
})

local GetSpellPowerCost = GetSpellPowerCost
local spellPowerCost = setmetatable({}, {
    __index = function(t, k)
        local v = GetSpellPowerCost(k)
        t[k] = v
        return v
    end
})

local floor = math.floor
local max = math.max
local GetActionInfo = GetActionInfo
local GetMacroSpell = GetMacroSpell
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local IsUsableAction = IsUsableAction
---@param action number
---@return number count
local function getActionCount(action)
    if not action then return 0, 0 end
    if not IsUsableAction(action) then return 0, 0 end
    if DB:Get("visibility", "ignoredActionSlots", action) then return 0, 0 end
    local actionType, id, subType = GetActionInfo(action)
    if actionType == "macro" then
        if DB:Get("visibility", "ignoredMacros", id) then return 0, 0 end
        actionType, id = "spell", GetMacroSpell(id)
    end
    if actionType ~= "spell" or not id then return 0, 0 end
    if DB:Get("visibility", "ignoredSpells", id) then return 0, 0 end
    if DB:Get("visibility", "cooldown", "hide") then
        local start, duration, enabled, modRate = GetSpellCooldown(id)
        if (start > 0 and duration > 0) and
            ((start + duration) > GetTime() +
                DB:Get("visibility", "cooldown", "threshold")) then
            return -1, 0
        end
    end
    local count = 0
    local maxCount = 0
    local costs = spellPowerCost[id]
    for i = 1, #costs do
        local cost = costs[i]
        if cost.cost > 0 then
            if power[cost.type] > 0 then
                count = max(count, power[cost.type] / cost.cost)
                maxCount = max(maxCount, maxPower[cost.type] / cost.cost)
            end
        end
    end
    return floor(count), floor(maxCount)
end

local actions = {}
---@param button table
local function updateCount(button)
    if button then
        local count, maxCount = getActionCount(actions[button])
        local fontString = fontStrings[button]
        if count > 0 then
            local threshold = DB:Get("visibility", "threshold")
            if count == maxCount and DB:Get("visibility", "hideIfMax") then
                fontString:Hide()
            elseif count < threshold or threshold == 0 then
                if DB:Get("visibility", "showMax") then
                    fontString:SetFormattedText("%d/%d", count, maxCount)
                else
                    fontString:SetText(count)
                end
                fontString:SetShown(count > 0)
                return
            end
        else
            fontString:Hide()
        end
        if count == -1 then addCheck(button) end
    else
        for i = 1, #buttons do updateCount(buttons[i]) end
    end
end

checkFrame.lastUpdate = 0
local pairs = pairs
checkFrame:SetScript("OnUpdate", function(self, elapsed)
    self.lastUpdate = self.lastUpdate + elapsed
    if self.lastUpdate >= 0.2 then
        self.lastUpdate = 0

        local flag = false
        for button in pairs(checks) do
            checks[button] = nil
            updateCount(button)
            flag = true
        end
        self:SetShown(flag)
    end
end)

---@param button table
local function update(button)
    if button then
        updateText(button)
        updateCount(button)
    else
        for i = 1, #buttons do update(buttons[i]) end
    end
end

local ActionButton_CalculateAction = ActionButton_CalculateAction
---@param button table
local function updateAction(button)
    if button then
        local action = ActionButton_CalculateAction(button)
        if actions[button] ~= action then
            actions[button] = action
            updateCount(button)
        end
    else
        for i = 1, #buttons do updateAction(buttons[i]) end
    end
end

local getPowerTypeFromToken
do -- getPowerTypeFromToken
    local lookup = {
        MANA = Enum.PowerType.Mana,
        RAGE = Enum.PowerType.Rage,
        FOCUS = Enum.PowerType.Focus,
        ENERGY = Enum.PowerType.Energy,
        HAPPINESS = Enum.PowerType.Happiness,
        RUNES = Enum.PowerType.Runes,
        RUNIC_POWER = Enum.PowerType.RunicPower,
        SOUL_SHARDS = Enum.PowerType.SoulShards,
        LUNAR_POWER = Enum.PowerType.LunarPower,
        HOLY_POWER = Enum.PowerType.HolyPower,
        ALTERNATE = Enum.PowerType.Alternate,
        MAELSTROM = Enum.PowerType.Maelstrom,
        CHI = Enum.PowerType.Chi,
        ARCANE_CHARGES = Enum.PowerType.ArcaneCharges,
        FURY = Enum.PowerType.Fury,
        PAIN = Enum.PowerType.Pain,
        INSANITY = Enum.PowerType.Insanity,
        COMBO_POINTS = Enum.PowerType.ComboPoints
    }
    ---@param powerToken string
    ---@return number powerType
    function getPowerTypeFromToken(powerToken) return lookup[powerToken] end
end

LibStub("LibJayEvent"):Register("ACTIONBAR_UPDATE_STATE", updateAction)

LibStub("LibJayEvent"):Register("ACTIONBAR_SLOT_CHANGED",
                                function() updateCount() end)

LibStub("LibJayEvent"):Register("ACTIONBAR_UPDATE_USABLE", updateCount)

LibStub("LibJayEvent"):Register("ACTIONBAR_UPDATE_COOLDOWN", updateCount)

local Wait = C_Timer.After
LibStub("LibJayEvent"):Register("ACTIONBAR_PAGE_CHANGED",
                                function() Wait(0.1, updateAction) end)

LibStub("LibJayEvent"):Register("UNIT_POWER_FREQUENT",
                                function(unitTarget, powerToken)
    if unitTarget == "player" then
        local powerType = getPowerTypeFromToken(powerToken)
        power[powerType] = UnitPower(unitTarget, powerType)
        updateCount()
    end
end)

LibStub("LibJayEvent"):Register("UNIT_MAXPOWER", function(unitTarget, powerType)
    if unitTarget == "player" then
        maxPower[powerType] = UnitPowerMax(unitTarget,
                                           getPowerTypeFromToken(powerType))
        updateCount()
    end
end)

local wipe = wipe
local function updateSpellPowerCost()
    wipe(spellPowerCost)
    updateCount()
end

local UnitPowerType = UnitPowerType
LibStub("LibJayEvent"):Register("PLAYER_ENTERING_WORLD",
                                function(isInitialLogin, isReloadingUi)
    local powerType = UnitPowerType("player")
    power[powerType] = UnitPower("player", powerType)
    maxPower[powerType] = UnitPowerMax("player", powerType)
    updateAction()
end)

LibStub("LibJayEvent"):Register("UNIT_DISPLAYPOWER",
                                function() updateCount() end)

LibStub("LibJayEvent"):Register("UNIT_AURA", function(unitTarget)
    if unitTarget == "player" then updateSpellPowerCost() end
end)
LibStub("LibJayEvent"):Register("CHARACTER_POINTS_CHANGED", updateSpellPowerCost)
LibStub("LibJayEvent"):Register("SPELLS_CHANGED", updateSpellPowerCost)

DB:RegisterCallback("OnChanged", function() update() end)

local error = error
local format = format
local tContains = tContains
local type = type
---@param button table
function AddOn.RegisterButton(button)
    if type(button) ~= "table" then
        error(format(
                  "Usage: %s:RegisterButton(button): 'button' - table expected got %s",
                  AddOnName, type(button)), 2)
    end

    if tContains(buttons, button) then return end
    buttons[#buttons + 1] = button

    fontStrings[button] = button:CreateFontString()
    updateText(button)
    updateAction(button)
    addCheck(button)
end
