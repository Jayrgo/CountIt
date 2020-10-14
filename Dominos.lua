if not LibStub("AceAddon-3.0", true) or not LibStub("AceAddon-3.0"):GetAddon("Dominos", true) then return end

local AddOnName, AddOn = ...

local function registerButtons()
    print("registerButtons")
    for id, button in pairs(Dominos.ActionButtons) do -- luacheck: ignore 213
        AddOn.RegisterButton(button)
    end
end

hooksecurefunc(getmetatable(LibStub("AceAddon-3.0"):GetAddon("Dominos").ActionButtons), "__index", registerButtons)
registerButtons()
