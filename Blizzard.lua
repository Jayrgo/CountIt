----@type string
local AddOnName = ...
---@type Addon
local AddOn = select(2, ...)

do -- ActionBars
    ---@param button CheckButton
    ---@return number
    local function getSpellIDCallback(button) return AddOn:GetSpellIDFromAction(AddOn:GetAction(button)) end

    for i = 1, 12 do
        AddOn:RegisterButton(_G["ActionButton" .. i], getSpellIDCallback)
        AddOn:RegisterButton(_G["MultiBarBottomLeftButton" .. i], getSpellIDCallback)
        AddOn:RegisterButton(_G["MultiBarBottomRightButton" .. i], getSpellIDCallback)
        AddOn:RegisterButton(_G["MultiBarLeftButton" .. i], getSpellIDCallback)
        AddOn:RegisterButton(_G["MultiBarRightButton" .. i], getSpellIDCallback)
    end
end

do -- SpellBook
    local buttons = {}

    ---@param button CheckButton
    ---@return number spellID
    local function getSpellIDCallback(button)
        if not button:IsVisible() then return end
        local slot, slotType, slotID = SpellBook_GetSpellBookSlot(button)
        return slotType == "SPELL" and slotID
    end

    for i = 1, 12 do
        local button = _G["SpellButton" .. i]
        buttons[#buttons + 1] = button
        AddOn:RegisterButton(button, getSpellIDCallback)
    end

    local function updateButtonsCount() for i = 1, #buttons do AddOn:UpdateButtonCount(buttons[i]) end end

    ---@param self Frame
    SpellBookSpellIconsFrame:HookScript("OnShow", function(self) updateButtonsCount() end)

    hooksecurefunc(_G, "SpellBookFrame_UpdateSpells", updateButtonsCount)
end

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then -- SpellFlyout
    local flyoutButtons = {}

    ---@param button CheckButton
    ---@return number spellID
    local function getSpellIDCallback(button) return button.spellID end

    hooksecurefunc(SpellFlyout, "Toggle",
                   function(self, flyoutID, parent, direction, distance, isActionBar, specID, showFullTooltip, reason)
        if self:IsShown() then
            local i = 1
            ---@type CheckButton
            local flyoutButton = _G["SpellFlyoutButton" .. i]

            while flyoutButton do
                if not flyoutButtons[flyoutButton] then
                    AddOn:RegisterButton(flyoutButton, getSpellIDCallback)
                    flyoutButtons[flyoutButton] = true
                end

                i = i + 1
                ---@type CheckButton
                flyoutButton = _G["SpellFlyoutButton" .. i]
            end
        end
    end)
end
