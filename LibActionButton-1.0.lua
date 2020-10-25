----@type string
local AddOnName = ...
---@type Addon
local AddOn = select(2, ...)

local function check()
    if LibStub("LibActionButton-1.0", true) then
        ---@param button CheckButton
        ---@return number
        local function getSpellIDCallback(button) return AddOn:GetSpellIDFromAction(AddOn:GetAction(button)) end

        ---@param eventname string
        ---@param button CheckButton
        LibStub("LibActionButton-1.0").RegisterCallback(AddOnName, "OnButtonCreated", function(eventname, button)
            AddOn:RegisterButton(button, getSpellIDCallback)
        end)
        return true
    end
end

if not check() then
    ---@param addon string
    local function ADDON_LOADED(addon)
        if check() then LibMan1:Get("LibEvent", 1):Unregister("ADDON_LOADED", ADDON_LOADED) end
    end
    LibMan1:Get("LibEvent", 1):Register("ADDON_LOADED", ADDON_LOADED)
end
