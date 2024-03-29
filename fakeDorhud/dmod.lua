if _G.DSBLT:IsDorhud() then return end
if _G.dorhudModuleCompat == nil then DSBLT:RunRequire("fakeDorhud/module") end
if _G.DMod then return end

_G.DMod = _G.NoOpTable.new()

-- Old global some mods use
_G.DorHUDMod = _G.DMod

DSBLT.allModules = {}

function DMod:new(name, details)
    if DSBLT.allModules[name] ~= nil then return DSBLT.allModules[name] end
    local moduleObject = _G.dorhudModuleCompat.new(name, details)
    DSBLT.allModules[name] = moduleObject
    return moduleObject
end