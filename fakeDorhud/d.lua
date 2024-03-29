if _G.DSBLT:IsDorhud() then return end
if not _G.DMod then DSBLT:RunRequire("fakeDorhud/dmod") end
if _G.D then return end

_G.D = _G.NoOpTable.new()

function D:module(name)
    return DSBLT.allModules[name]
end

function D:root_path()
    return "mods/"
end