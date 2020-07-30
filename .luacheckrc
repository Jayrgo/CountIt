-- luacheck: ignore
std = "lua51"
max_line_length = false
exclude_files = {"Libs/", ".luacheckrc", ".luaformat"}
ignore = {
    "211", -- Unused local variable
    "212", -- Unused argument
}
globals = {
    "CreateFrame", "LibStub", "UnitPower", "UnitPowerMax", "GetSpellPowerCost", "GetActionInfo", "GetMacroSpell",
    "GetSpellCooldown", "GetTime", "IsUsableAction", "ActionButton_CalculateAction", "Enum", "UnitPowerType", "C_Timer",
    "format", "tContains", "wipe", "hooksecurefunc", "Dominos", "BOOKTYPE_SPELL", "GetActionTexture", "GetMacroInfo",
    "GetSpellBookItemName", "GetSpellBookItemTexture", "GetAddOnInfo", "GetAddOnMetadata", "GetLocale",
}
