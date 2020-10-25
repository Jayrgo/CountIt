----@type string
local AddOnName = ...
---@type Addon
local AddOn = select(2, ...)

local L = AddOn.L
local DB = AddOn.DB

local max = math.max
local wipe = wipe

local LSM = LibStub("LibSharedMedia-3.0")

local getDbValue, setDbValue, getDefaultDbValue = LibMan1:Get("LibDatabaseOptions", 1):GetOptionFunctions(DB)

---@type fun(info:table)
local fillInfoWithSpells
if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    local BOOKTYPE_SPELL = BOOKTYPE_SPELL
    local GetSpellBookItemName = GetSpellBookItemName
    local GetSpellBookItemTexture = GetSpellBookItemTexture

    ---@param info table
    function fillInfoWithSpells(info)
        local spellNames = info.arg[1]
        local spellIcons = info.arg[2]

        wipe(spellNames)
        wipe(spellIcons)

        local i = 0
        while true do
            i = i + 1
            local spellName, spellSubName, spellID = GetSpellBookItemName(i, BOOKTYPE_SPELL)
            if spellName then
                local fullSpellName = spellName .. (spellSubName ~= "" and (" (" .. spellSubName .. ")") or "")
                spellNames[spellID] = fullSpellName
                spellIcons[spellID] = GetSpellBookItemTexture(i, BOOKTYPE_SPELL)
            else
                break
            end
        end
    end
else
    local BOOKTYPE_SPELL = BOOKTYPE_SPELL
    local GetNumSpellTabs = GetNumSpellTabs
    local GetSpellTabInfo = GetSpellTabInfo
    local GetSpellBookItemInfo = GetSpellBookItemInfo
    local GetFlyoutInfo = GetFlyoutInfo
    local GetFlyoutSlotInfo = GetFlyoutSlotInfo
    local GetSpellTexture = GetSpellTexture
    local GetSpellBookItemName = GetSpellBookItemName
    local GetSpellBookItemTexture = GetSpellBookItemTexture

    ---@param info table
    function fillInfoWithSpells(info)
        local spellNames = info.arg[1]
        local spellIcons = info.arg[2]

        wipe(spellNames)
        wipe(spellIcons)

        local numTabs = GetNumSpellTabs()
        for numTab = 1, numTabs do
            local name, texture, offset, numEntries, isGuild, offspecID = GetSpellTabInfo(numTab)
            for index = offset, offset + numEntries do
                local skillType, special = GetSpellBookItemInfo(index, BOOKTYPE_SPELL)
                if skillType == "FLYOUT" then
                    local flyoutName, flyoutDesc, flyoutNumSlots = GetFlyoutInfo(special)
                    for numFlyout = 1, flyoutNumSlots do
                        local spellID, overrideSpellID, isKnown, spellName, slotSpecID =
                            GetFlyoutSlotInfo(special, numFlyout)
                        spellNames[spellID] = spellName
                        spellIcons[spellID] = GetSpellTexture(overrideSpellID)
                    end
                else
                    local spellName, spellSubName, spellID = GetSpellBookItemName(index, BOOKTYPE_SPELL)
                    if spellName then
                        local fullSpellName = spellName .. (spellSubName ~= "" and (" (" .. spellSubName .. ")") or "")
                        spellNames[spellID] = fullSpellName
                        spellIcons[spellID] = GetSpellBookItemTexture(index, BOOKTYPE_SPELL)
                    end
                end
            end
        end
    end
end

local GetActionTexture = GetActionTexture
local GetMacroInfo = GetMacroInfo

LibMan1:Get("LibOptions", 1):New(select(2, GetAddOnInfo(AddOnName)), {
    { -- Version
        type = "string",
        text = L.VERSION,
        get = "|cffbebebe" .. GetAddOnMetadata(AddOnName, "Version") .. "|r",
        isReadOnly = true,
        justifyH = "RIGHT",
    },
    { -- appearance
        type = "header",
        text = L.APPEARANCE,
        path = "appearance",
        optionList = {
            { -- font
                type = "select",
                text = L.FONT,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "font",
                values = function(info)
                    local values = {}

                    local mediaList = LSM:List(LSM.MediaType.FONT)
                    for i = 1, #mediaList do values[mediaList[i]] = mediaList[i] end

                    return values
                end,
            },
            { -- height
                type = "number",
                text = L.HEIGHT,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "height",
                --[[ step = 0.5, ]]
                min = 7,
                max = 30,
            },
            { -- shadow
                type = "boolean",
                text = L.SHADOW,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "shadow",
            },
            { -- outline
                type = "boolean",
                text = L.OUTLINE,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "outline",
            },
            { -- scale
                type = "number",
                text = L.SCALE,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                min = 0.25,
                max = 3,
                isPercent = true,
                path = "scale",
            },
            { -- color
                type = "color",
                text = L.COLOR,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "color",
                hasAlpha = true,
            },
        },
    },
    { -- visibility
        type = "header",
        text = L.VISIBILITY,
        path = "visibility",
        optionList = {
            { -- showMax
                type = "boolean",
                text = L.SHOW_MAX,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "showMax",
            },
            { -- hideIfMax
                type = "boolean",
                text = L.HIDE_IF_EQUAL_TO_MAX,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "hideIfMax",
            },
            { -- threshold
                type = "number",
                text = L.THRESHOLD,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                min = 0,
                max = function(info) return info.arg[1] end,
                minText = L.OFF,
                path = "threshold",
                onUpdate = function(info)
                    local threshold = DB:Get("visibility", "threshold")
                    if threshold == info.arg[1] then
                        info.arg[1] = info.arg[1] + 10
                    elseif threshold + 10 < info.arg[1] then
                        info.arg[1] = max(info.arg[1] - 10, 10)
                    elseif threshold > info.arg[1] then
                        while true do
                            info.arg[1] = info.arg[1] + 10
                            if threshold < info.arg[1] then break end
                        end
                    end
                end,
                onUpdateInterval = 0.2,
                arg = {10},
            },
            { -- mouseOver
                type = "boolean",
                text = L.MOUSE_OVER,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "mouseOver",
            },
            { -- ignoredSpells
                type = "select",
                text = L.IGNORED_SPELLS,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                isMulti = true,
                path = "ignoredSpells",
                values = function(info) return info.arg[1] end,
                icons = function(info) return info.arg[2] end,
                onRefresh = fillInfoWithSpells,
                arg = {{}, {}},
            },
            { -- ignoredActionSlots
                type = "select",
                text = L.IGNORED_ACTION_SLOTS,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                isMulti = true,
                path = "ignoredActionSlots",
                values = function(info) return info.arg[1] end,
                sortByKeys = true,
                icons = function(info) return info.arg[2] end,
                onUpdate = function(info)
                    wipe(info.arg[1])
                    wipe(info.arg[2])

                    for i = 1, 132 do
                        info.arg[1][i] = i
                        info.arg[2][i] = GetActionTexture(i)
                    end
                end,
                onUpdateInterval = 1,
                arg = {{}, {}},
            },
            { -- ignoredMacros
                type = "select",
                text = L.IGNORED_MACROS,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                isMulti = true,
                path = "ignoredMacros",
                values = function(info) return info.arg[1] end,
                sortByKeys = true,
                icons = function(info) return info.arg[2] end,
                onUpdate = function(info)
                    local arg = info.arg
                    wipe(arg[1])
                    wipe(arg[2])

                    for i = 1, 120 do
                        local name, icon = GetMacroInfo(i)
                        arg[1][i] = name
                        arg[2][i] = icon
                    end
                    for i = 121, 138 do
                        local name, icon = GetMacroInfo(i)
                        arg[1][i] = name
                        arg[2][i] = icon
                    end
                end,
                onUpdateInterval = 1,
                arg = {{}, {}},
            },
            { -- cooldown
                type = "header",
                text = L.COOLDOWN,
                path = "cooldown",
                optionList = {
                    { -- hide
                        type = "boolean",
                        text = L.HIDE,
                        get = getDbValue,
                        set = setDbValue,
                        default = getDefaultDbValue,
                        path = "hide",
                    },
                    { -- threshold
                        type = "number",
                        text = L.THRESHOLD,
                        get = getDbValue,
                        set = setDbValue,
                        default = getDefaultDbValue,
                        path = "threshold",
                        min = 0,
                        max = function(info) return info.arg[1] end,
                        step = 0.1,
                        onUpdate = function(info)
                            local threshold = DB:Get("visibility", "cooldown", "threshold")
                            if threshold == info.arg[1] then
                                info.arg[1] = info.arg[1] + 10
                            elseif threshold + 10 < info.arg[1] then
                                info.arg[1] = max(info.arg[1] - 10, 10)
                            elseif threshold > info.arg[1] then
                                while true do
                                    info.arg[1] = info.arg[1] + 10
                                    if threshold < info.arg[1] then break end
                                end
                            end
                        end,
                        onUpdateInterval = 0.2,
                        arg = {10},
                    },
                },
            },
        },
    },
    { -- position
        type = "header",
        text = L.POSITION,
        path = "position",
        optionList = {
            { -- point
                type = "select",
                text = L.ANCHOR,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                values = {
                    LEFT = L.LEFT,
                    TOP = L.TOP,
                    RIGHT = L.RIGHT,
                    BOTTOM = L.BOTTOM,
                    TOPLEFT = L.TOPLEFT,
                    TOPRIGHT = L.TOPRIGHT,
                    BOTTOMLEFT = L.BOTTOMLEFT,
                    BOTTOMRIGHT = L.BOTTOMRIGHT,
                    CENTER = L.CENTER,
                },
                path = "point",
            },
            { -- ofsx
                type = "number",
                text = L.X_OFFSET,
                min = -20,
                max = 20,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                path = "ofsx",
            },
            { -- ofsy
                type = "number",
                text = L.Y_OFFSET,
                get = getDbValue,
                set = setDbValue,
                default = getDefaultDbValue,
                min = -20,
                max = 20,
                path = "ofsy",
            },
        },
    },
})
LibMan1:Get("LibDatabaseOptions", 1):New(DB, select(2, GetAddOnInfo(AddOnName)))
