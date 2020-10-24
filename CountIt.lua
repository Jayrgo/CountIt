----@type string
local AddOnName = ...
---@type Addon
local AddOn = select(2, ...)

local L = AddOn.L
local DB = AddOn.DB

---@type Frame
local checkFrame = CreateFrame("Frame")
checkFrame:Hide()

---@type table<CheckButton, boolean>
local checks = {}

---@param button table
local function addCheck(button)
    checks[button] = true
    checkFrame:Show()
end

---@type CheckButton[]
local buttons = {}
local fontStrings = {}
local LSM = LibStub("LibSharedMedia-3.0")

---@param button CheckButton
local function updateText(button)
    if button then
        ---@type FontString
        local fontString = fontStrings[button]
        fontString:SetDrawLayer(DB:Get("visibility", "mouseOver") and "HIGHLIGHT" or "OVERLAY")
        fontString:ClearAllPoints()
        fontString:SetPoint(DB:Get("position", "point"), DB:Get("position", "ofsx"), DB:Get("position", "ofsy"))
        fontString:SetScale(DB:Get("appearance", "scale"))
        fontString:SetFont(LSM:Fetch(LSM.MediaType.FONT, DB:Get("appearance", "font")), DB:Get("appearance", "height"),
                           DB:Get("appearance", "outline") and "OUTLINE" or "")
        fontString:SetTextColor(DB:Get("appearance", "color", "r"), DB:Get("appearance", "color", "g"),
                                DB:Get("appearance", "color", "b"), DB:Get("appearance", "color", "a"))
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

---@type table<PowerType, number>
local power = setmetatable({}, {
    ---@param t table<PowerType, number>
    ---@param k PowerType
    ---@return number
    __index = function(t, k)
        local power = UnitPower("player", k)
        t[k] = power
        return power
    end,
})

local UnitPowerMax = UnitPowerMax

---@type table<PowerType, number>
local maxPower = setmetatable({}, {
    ---@param t table<PowerType, number>
    ---@param k PowerType
    ---@return number
    __index = function(t, k)
        local maxpower = UnitPowerMax("player", k)
        t[k] = maxpower
        return maxpower
    end,
})

---@type table<number, boolean>
local CONSUMES_ALL = {}

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    ---@type table<number, boolean>
    CONSUMES_ALL = {
        -- Execute
        [5308] = true, -- Rank 1
        [20658] = true, -- Rank 2
        [20660] = true, -- Rank 3
        [20661] = true, -- Rank 4
        [20662] = true, -- Rank 5
        -- Eviscerate
        [2098] = true, -- Rank 1
        [6760] = true, -- Rank 2
        [6761] = true, -- Rank 3
        [6762] = true, -- Rank 4
        [8623] = true, -- Rank 5
        [8624] = true, -- Rank 6
        [11299] = true, -- Rank 7
        [11300] = true, -- Rank 8
        [31016] = true, -- Rank 9
        -- Slice and Dice
        [5171] = true, -- Rank 1
        [6774] = true, -- Rank 2
        -- Expose Armor
        [8647] = true, -- Rank 1
        [8649] = true, -- Rank 2
        [8650] = true, -- Rank 3
        [11197] = true, -- Rank 4
        [11198] = true, -- Rank 5
        -- Rupture
        [1943] = true, -- Rank 1
        [8639] = true, -- Rank 2
        [8640] = true, -- Rank 3
        [11273] = true, -- Rank 4
        [11274] = true, -- Rank 5
        [11275] = true, -- Rank 6
        -- Rip
        [1079] = true, -- Rank 1
        [9492] = true, -- Rank 2
        [9493] = true, -- Rank 3
        [9752] = true, -- Rank 4
        [9894] = true, -- Rank 5
        [9896] = true, -- Rank 6
        -- Ferocious Bite
        [22568] = true, -- Rank 1
        [22827] = true, -- Rank 2
        [22828] = true, -- Rank 3
        [22829] = true, -- Rank 4
        [31018] = true, -- Rank 5
    }
end

local GetSpellPowerCost = GetSpellPowerCost

---@type table<number, table>
local spellPowerCost = setmetatable({}, {
    ---@param t table<number, table>
    ---@param k number
    ---@return table<string, any>
    __index = function(t, k)
        ---@type table<string, any>
        local v = GetSpellPowerCost(k)
        t[k] = v
        return v
    end,
})

local floor = floor
local max = max
local GetActionInfo = GetActionInfo
local GetMacroSpell = GetMacroSpell
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local IsUsableAction = IsUsableAction

---@param action number
---@return number count
---@return number maxCount
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
            ((start + duration) > GetTime() + DB:Get("visibility", "cooldown", "threshold")) then return -1, 0 end
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

    if CONSUMES_ALL[id] then
        count = count > 1 and 1 or count
        maxCount = maxCount > 1 and 1 or maxCount
    end

    return floor(count), floor(maxCount)
end

---@type table<CheckButton, number>
local actions = {}

---@param button CheckButton
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

---@param self Frame
---@param elapsed number
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

---@param button CheckButton
local function update(button)
    if button then
        updateText(button)
        updateCount(button)
    else
        for i = 1, #buttons do update(buttons[i]) end
    end
end

---@param button CheckButton
---@return number
local function getAction(button) return button:CalculateAction() end

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    local ActionButton_CalculateAction = ActionButton_CalculateAction

    ---@type CheckButton
    ---@return number
    function getAction(button) return ActionButton_CalculateAction(button) end
end

---@param button CheckButton
local function updateAction(button)
    if button then
        local action = getAction(button)

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
    local lookup = {}

    for k, v in pairs(Enum.PowerType) do lookup[strupper(k)] = v end

    ---@param powerToken string
    ---@return number powerType
    function getPowerTypeFromToken(powerToken) return lookup[powerToken] end
end

LibMan1:Get("LibEvent", 1):Register("ACTIONBAR_UPDATE_STATE", updateAction)

LibMan1:Get("LibEvent", 1):Register("ACTIONBAR_SLOT_CHANGED", function() updateCount() end)

LibMan1:Get("LibEvent", 1):Register("ACTIONBAR_UPDATE_USABLE", updateCount)

LibMan1:Get("LibEvent", 1):Register("ACTIONBAR_UPDATE_COOLDOWN", updateCount)

local Wait = C_Timer.After

LibMan1:Get("LibEvent", 1):Register("ACTIONBAR_PAGE_CHANGED", function() Wait(0.1, updateAction) end)

---@param unitTarget string
---@param powerToken string
LibMan1:Get("LibEvent", 1):Register("UNIT_POWER_FREQUENT", function(unitTarget, powerToken)
    if unitTarget == "player" then
        local powerType = getPowerTypeFromToken(powerToken)
        power[powerType] = UnitPower(unitTarget, powerType)
        updateCount()
    end
end)

---@param unitTarget string
---@param powerType PowerType
LibMan1:Get("LibEvent", 1):Register("UNIT_MAXPOWER", function(unitTarget, powerType)
    if unitTarget == "player" then
        maxPower[powerType] = UnitPowerMax(unitTarget, powerType)
        updateCount()
    end
end)

local wipe = wipe

local function updateSpellPowerCost()
    wipe(spellPowerCost)
    updateCount()
end

local UnitPowerType = UnitPowerType

---@param isInitialLogin boolean
---@param isReloadingUi boolean
LibMan1:Get("LibEvent", 1):Register("PLAYER_ENTERING_WORLD", function(isInitialLogin, isReloadingUi)
    local powerType = UnitPowerType("player")
    power[powerType] = UnitPower("player", powerType)
    maxPower[powerType] = UnitPowerMax("player", powerType)
    updateAction()
end)

LibMan1:Get("LibEvent", 1):Register("UNIT_DISPLAYPOWER", function() updateCount() end)

---@param unitTarget string
LibMan1:Get("LibEvent", 1):Register("UNIT_AURA",
                                    function(unitTarget) if unitTarget == "player" then updateSpellPowerCost() end end)
LibMan1:Get("LibEvent", 1):Register("CHARACTER_POINTS_CHANGED", updateSpellPowerCost)
LibMan1:Get("LibEvent", 1):Register("SPELLS_CHANGED", updateSpellPowerCost)

DB:RegisterCallback("OnChanged", function() update() end)

local error = error
local format = format
local tContains = tContains
local type = type

---@param button CheckButton
function AddOn.RegisterButton(button)
    if type(button) ~= "table" then
        error(format("Usage: %s:RegisterButton(button): 'button' - table expected got %s", AddOnName, type(button)), 2)
    end

    if tContains(buttons, button) then return end
    buttons[#buttons + 1] = button

    ---@type FontString
    fontStrings[button] = button:CreateFontString()
    updateText(button)
    updateAction(button)
    addCheck(button)
end
