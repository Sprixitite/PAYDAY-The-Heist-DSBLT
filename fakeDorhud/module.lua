if _G.DSBLT:IsDorhud() then return end
if _G.DSBLT.moduleOptions == nil then DSBLT:RunRequire("fakeDorhud/moduleOptions") end
if _G.DSBLT.optionsMenus == nil then DSBLT:RunRequire("fakeDorhud/optionsMenus") end
if _G.dorhudModuleCompat then return end

_G.dorhudModuleCompat = {}
dorhudModuleCompat.__index = dorhudModuleCompat

function dorhudModuleCompat.new(name, details)

    local module = { name = name }
    if details ~= nil then
        for i, v in next, details do
            module[i] = v
        end
    end
    setmetatable(module, dorhudModuleCompat)

    module:registerHooks()

    return module

end

-- Adds hooks at runtime that the mod.txt generator couldn't convert
-- I.e: Hooks included in the call to DMod:new()
function dorhudModuleCompat:registerHooks()

    if self.hooks == nil then return end
    
    for _, hook in next, self.hooks do
        
        local file = hook[1]
        local hook_func = hook[2]

        if not _G.DSBLT.runtimeHooks:IsHookedTo(file:lower()) then
            DSBLT:GetModule():AddHook("hooks", file:lower(), "fakeDorhud/runtimehooks.lua", _G.BLT.hook_tables.post, _G.BLT.hook_tables.wildcards, {"pdth"})
            _G.DSBLT.runtimeHooks:HookTo(file:lower())
        end

    end

end

--- Hooks --------------
dorhudModuleCompat.call_orig = DSBLT.CallOrig
dorhudModuleCompat.hook = DSBLT.OverrideHook
dorhudModuleCompat.post_hook = function(self, hookClass, hooking, hookFunc)
    DSBLT:PostHook(hookClass, hooking, DSBLT:HookId(hooking, self.name), hookFunc)
end
dorhudModuleCompat.pre_hook = function(self, hookClass, hooking, hookFunc)
    DSBLT:PreHook(hookClass, hooking, DSBLT:HookId(hooking, self.name), hookFunc)
end
dorhudModuleCompat.hook_class = DSBLT.HookClass

--- Options --------------
dorhudModuleCompat.add_config_option = function(self, id, default, ...)
    local keyAliases = {...}
    if #keyAliases ~= 0 then
        DSBLT:Log("Mod \"" .. self.name .. "\" attempted to use key aliases when creating mod option!")
        DSBLT:Log("Passed values are as follows: ")
        for k, v in next, keyAliases do
            DSBLT:Log("Key: " .. tostring(k))
            DSBLT:Log("Value: " .. tostring(v))
        end
    end

    DSBLT.moduleOptions:AddOption(DSBLT:HookId(id, self.name), default)
end

dorhudModuleCompat.conf = function(self, id)
    return DorHUD:conf( DSBLT:HookId(id, self.name) )
end

dorhudModuleCompat.add_menu_option = function(self, configId, menuOptInfo)
    DSBLT.optionsMenus:AddControl( self.name, menuOptInfo )
end

dorhudModuleCompat.add_localization_string = function(self, id, strings, ...)
    DSBLT:AddLocString(id, strings, ...)
end

--- Files --------------
dorhudModuleCompat.register_include = DSBLT.RunRequire

-- Both of these are the same, old naming scheme again
-- These are ignored because the mod.txt generator should handle these
dorhudModuleCompat.hook_post_require = function() end
dorhudModuleCompat.register_post_override = function() end