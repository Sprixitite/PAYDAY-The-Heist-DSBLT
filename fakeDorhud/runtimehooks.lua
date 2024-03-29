-- File for managing runtime hooks that can't be converted
-- Before running Dahm mods e.g: hooks in DMod:new()

if _G.DSBLT:IsDorhud() then return end

_G.DSBLT.runtimeHooks = _G.DSBLT.runtimeHooks or {
    hookedTo = {},

    IsHookedTo = function(self, which)
        return self.hookedTo[which] ~= nil
    end,

    HookTo = function(self, which)
        DSBLT:Log("Hooked RuntimeHooks to file " .. which)
        self.hookedTo[#self.hookedTo+1] = which
    end
}

DSBLT:Log("RuntimeHooks ran with RequiredScript: " .. tostring(RequiredScript))

if _G.DSBLT.allModules == nil then return end

for _, module in next, _G.DSBLT.allModules do

    DSBLT:Log("Inspecting hooks for mod: " .. tostring(module.name))
    
    if module.hooks ~= nil then

        DSBLT:Log( tostring(#module.hooks) .. " hooks found for mod " .. tostring(module.name))
        
        for _, hook in next, module.hooks do
            
            local hookScript = hook[1]
            local hookFunc = hook[2]

            if hookScript == RequiredScript then
                
                hookFunc(module)

            end

        end

    end

end