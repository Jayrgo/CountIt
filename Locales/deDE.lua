if GetLocale() ~= "deDE" then return end

----@type string
local AddOnName = ...
---@type Addon
local AddOn = select(2, ...)

local L = AddOn.L

L.ANCHOR = "Anker"
L.APPEARANCE = "Aussehen"
L.BOTTOM = "Unten"
L.BOTTOMLEFT = "UntenLinks"
L.BOTTOMRIGHT = "UntenRechts"
L.CENTER = "Mitte"
L.COOLDOWN = "Abklingzeit"
L.FONT = "Schriftart"
L.HEIGHT = "Höhe"
L.HIDE_IF_EQUAL_TO_MAX = "Ausblenden, wenn gleich Maximum"
L.IGNORED_ACTION_SLOTS = "Ignorierte Aktionsslots"
L.IGNORED_MACROS = "Ignorierte Makros"
L.IGNORED_SPELLS = "Ignorierte Zauber"
L.LEFT = "Links"
L.MEMORY_USAGE = "Speicherverbrauch"
L.MOUSE_OVER = "Mouse Over"
L.OUTLINE = "Umriss"
L.POSITION = "Position"
L.RIGHT = "Rechts"
L.SCALE = "Skalierung"
L.SHADOW = "Schatten"
L.SHOW_MAX = "Zeige Maximum"
L.SIZE = "Größe"
L.TOP = "Oben"
L.TOPLEFT = "ObenLinks"
L.TOPRIGHT = "ObenRechts"
L.THRESHOLD = "Schwelle (kleiner als)"
L.VERSION = "Version"
L.VISIBILITY = "Sichtbarkeit"
L.X_OFFSET = "X-Versatz"
L.Y_OFFSET = "Y-Versatz"
