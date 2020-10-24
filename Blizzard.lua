----@type string
local AddOnName = ...
---@type Addon
local AddOn = select(2, ...)

for i = 1, 12 do
    AddOn.RegisterButton(_G["ActionButton" .. i])
    AddOn.RegisterButton(_G["MultiBarBottomLeftButton" .. i])
    AddOn.RegisterButton(_G["MultiBarBottomRightButton" .. i])
    AddOn.RegisterButton(_G["MultiBarLeftButton" .. i])
    AddOn.RegisterButton(_G["MultiBarRightButton" .. i])
end
