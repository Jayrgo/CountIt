local AddOnName, AddOn = ...

local function check()
    if LibStub("LibActionButton-1.0", true) then
        LibStub("LibActionButton-1.0").RegisterCallback(AddOnName,
                                                        "OnButtonCreated",
                                                        function(eventname,
                                                                 button)
            AddOn.RegisterButton(button)
        end)
        return true
    end
end

if not check() then
    local function ADDON_LOADED(addon)
        if check() then
            LibStub("LibJayEvent"):Unregister("ADDON_LOADED", ADDON_LOADED)
        end
    end
    LibStub("LibJayEvent"):Register("ADDON_LOADED", ADDON_LOADED)
end
