local AddOnName, AddOn = ...

local _G = _G
--[[ local error = error
local format = format ]]
AddOn.L = setmetatable({}, {
    __index = function(t, k)
        local v = _G[k]
        --[[ if not v then
            error(format("%s: Missing localization entry for %s.", AddOnName, k))
        end ]]
        t[k] = v
        return v
    end
})

local L = AddOn.L

L.ANCHOR = "Anchor"
L.APPEARANCE = "Appearance"
L.BOTTOM = "Bottom"
L.BOTTOMLEFT = "BottomLeft"
L.BOTTOMRIGHT = "BottomRight"
L.CENTER = "Center"
L.COOLDOWN = "Cooldown"
L.FONT = "Font"
L.HEIGHT = "Height"
L.HIDE_IF_EQUAL_TO_MAX = "Hide If Equal To Max"
L.IGNORED_ACTION_SLOTS = "Ignored Action Slots"
L.IGNORED_MACROS = "Ignored Macros"
L.IGNORED_SPELLS = "Ignored Spells"
L.LEFT = "Left"
L.MEMORY_USAGE = "Memory Usage"
L.MOUSE_OVER = "Mouse Over"
L.OUTLINE = "Outline"
L.POSITION = "Position"
L.RIGHT = "Right"
L.SCALE = "Scale"
L.SHADOW = "Shadow"
L.SHOW_MAX = "Show Max"
L.SIZE = "Size"
L.TOP = "Top"
L.TOPLEFT = "TopLeft"
L.TOPRIGHT = "TopRight"
L.THRESHOLD = "Threshold (less than)"
L.VERSION = "Version"
L.VISIBILITY = "Visibility"
L.X_OFFSET = "X-Offset"
L.Y_OFFSET = "Y-Offset"
