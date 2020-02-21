if not LibStub("AceAddon-3.0", true) or
    not LibStub("AceAddon-3.0"):GetAddon("Dominos", true) then return end

local AddOnName, AddOn = ...

local function registerButtons()
    for id, button in pairs(Dominos.ActionButton.active) do -- luacheck: ignore 213
        AddOn.RegisterButton(button)
    end
end

hooksecurefunc(LibStub("AceAddon-3.0"):GetAddon("Dominos").ActionButton, "New",
               registerButtons)
registerButtons()
