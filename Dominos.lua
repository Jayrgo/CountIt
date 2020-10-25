if not LibStub("AceAddon-3.0", true) or not LibStub("AceAddon-3.0"):GetAddon("Dominos", true) then return end

----@type string
local AddOnName = ...
---@type Addon
local AddOn = select(2, ...)

---@param button CheckButton
---@return number
local function getSpellIDCallback(button) return AddOn:GetSpellIDFromAction(AddOn:GetAction(button)) end

local function registerButtons()
    for id, button in pairs(Dominos.ActionButtons) do -- luacheck: ignore 213
        AddOn:RegisterButton(button, getSpellIDCallback)
    end
end

hooksecurefunc(getmetatable(LibStub("AceAddon-3.0"):GetAddon("Dominos").ActionButtons), "__index", registerButtons)
registerButtons()
