if _G.DSBLT:IsDorhud() then return end

_G.DSBLT.moduleOptions = _G.DSBLT.moduleOptions or {
    dataPath = SavePath .. "DSBLT-Compat.txt",
    data = {},
    dataDefaults = {}
}

-- Below code is modified code taken from
-- HLM2 Combo Counter Improved
-- Original code by eightan (thanks!)

_G.DSBLT.moduleOptions.Save = function(self)
    local file = io.open( self.dataPath, "w+" )
    if file then
        file:write( json.encode( self.data ) )
        file:close()
    end
end

_G.DSBLT.moduleOptions.Load = function(self)
    local file = io.open( self.dataPath, "r" )
    if file then
        self.data = json.decode( file:read("*all") )
        file:close()
    end
end

local function getDefaultValue(id)
    return _G.DSBLT.moduleOptions.dataDefaults[id]
end

_G.DSBLT.moduleOptions.GetOption = function(self, id)
    if self.data[id] == nil then
        error("Attempt to retrieve nonexistent option \"" .. tostring(id) .. "\"!")
    end

    local currentOptionVal = self.data[id]

    -- Assume if the current value ~= the default value
    -- That the user has changed it
    -- Done because DorHud returns a bool denoting if the user set the returned value
    return currentOptionVal, currentOptionVal ~= getDefaultValue(id)
end

_G.DSBLT.moduleOptions.AddOption = function(self, id, default)
    DSBLT:Log("Added option \"" .. tostring(id) .. "\" with default: \"" .. tostring(default) .. "\"")
    self.dataDefaults[id] = default
    if self.data[id] == nil then
        self.data[id] = default
        _G.DSBLT.moduleOptions:Save()
    end
end