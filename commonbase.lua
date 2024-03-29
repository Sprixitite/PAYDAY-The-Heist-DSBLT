local dorhudModule = ... or D and D:module("DSBLT")

if _G.DSBLT then return end

local dorhudGlobals = {
    D = _G.D,
    DMod = _G.DMod or _G.DorHUDMod,
    DLocalizer = _G.DLocalizer,
    DorHUD = _G.DorHUD,
    dorhudModule = dorhudModule,
    dorhudFileHandler = rawget(_G, "File") or rawget(_G, "file"),
}

_G.DSBLT = { contextName = nil }
_G.DSBLT.__dorhudGlobals = dorhudGlobals

---@return boolean
function DSBLT:IsSBLT()
    return dorhudGlobals.DMod == nil
end

---@return boolean
function DSBLT:IsDorhud()
    return not DSBLT:IsSBLT()
end

---@param modName string
function DSBLT:ModPath(modName)
    return DSBLT:ModRoot() .. modName .. "/"
end

---@return string
function DSBLT:ModRoot()
    if DSBLT:IsSBLT() then
        return "mods/"
    else
        return D:root_path()
    end
end

---@param toRun string
function DSBLT:RunRequire(toRun)
    if DSBLT:IsSBLT() then
        dofile(DSBLT:ModPath("DSBLT") .. toRun .. ".lua")
    else
        DSBLT:GetModule():register_include(toRun)
    end
end

---@param className string
---@return any
function DSBLT:HookClass(className)
    return function()
        if DSBLT:IsDorhud() then
            return DSBLT:GetModule():hook_class(className)
        else
            return rawget(_G, className)
        end
    end
end

---Collapses a classHook into the hooked class it represents
---@param candidate userdata|table|function
---@return table
function DSBLT:GetClass(candidate)
    if type(candidate) == "function" then
        return candidate()
    elseif type(candidate) == "table" or type(candidate) == "userdata" then
        return candidate
    elseif candidate == nil then
        error("Attempt to hook nil")
    else
        error("Attempt to hook a primitive?")
    end
end
function DSBLT:HookId(prefix, suffix)
    if string.match(prefix, "_DSBLT%-Compat_") ~= nil or string.match(suffix, "_DSBLT%-Compat_") ~= nil then
        error("Attempt to hookId a string that was already hookId'd!")
    end
    return prefix .. "_DSBLT-Compat_" .. suffix
end

function DSBLT:HookedClassExists(classHook)
    if classHook == nil then return false end
    return DSBLT:GetClass(classHook) ~= nil
end

---@param class any
---@param hookName string
---@param hookId string
---@param hookFunc function
function DSBLT:PostHook(class, hookName, hookId, hookFunc)
    class = DSBLT:GetClass(class)
    if DSBLT:IsSBLT() then
        Hooks:PostHook(class, hookName, hookId, hookFunc)
    else
        DSBLT:GetModule():post_hook(class, hookName, hookFunc)
    end
end

---@param class any
---@param hookName string
---@param hookId string
---@param hookFunc function
function DSBLT:PreHook(class, hookName, hookId, hookFunc)
    class = DSBLT:GetClass(class)
    if DSBLT:IsSBLT() then
        Hooks:PreHook(class, hookName, hookId, hookFunc)
    else
        DSBLT:GetModule():pre_hook(class, hookName, hookFunc)
    end
end

function DSBLT:OverrideHook(class, hookName, hookFunc)
    class = DSBLT:GetClass(class)
    if DSBLT:IsSBLT() then
        Hooks:OverrideFunction(class, hookName, hookFunc)
    else
        DSBLT:GetModule():hook(class, hookName, hookFunc)
    end
end 

local function configID(oldName)
    return "DSBLT-Compat_" .. oldName
end

-- I have yet to see an example of the "optional key aliases"
-- The archived dorhud "docs" make mention of
-- As such these aren't supported
function DSBLT:AddConfigOption(optionName, default)
    if DSBLT:IsSBLT() then
        
    else
        dorhudGlobals.DorHUD:add_config_option(optionName, default)
    end
end

function DSBLT:GetConfigOption(optionName)
    if DSBLT:IsSBLT() then
        
    else
        return dorhudGlobals.DorHUD:conf(optionName)
    end
end

function DSBLT:CallOrig(class, funcName, ...)
    local args = {...}
    DSBLT:GetOrig(class, funcName)(unpack(args))
end

function DSBLT:GetOrig(class, funcName)
    class = DSBLT:GetClass(class)
    if DSBLT:IsSBLT() then
        return Hooks:GetFunction(class, funcName)
    else
        return function(...)
            local args = {...}
            DSBLT:GetModule():call_orig(class, funcName, unpack(args))
        end
    end
end

---@param assetType string
---@param assetPath string
---@return boolean
function DSBLT:AddAsset(assetType, assetPath)
    if not DSBLT:CanAddFiles() then
        DSBLT:Log(
            "DSBLT WARNING: DorHUD/Dahm doesn't support adding files without manual bundle editing\n" ..
            "Consider using SuperBLT if you wish to add files, or try to reuse existing game content\n" ..
            "This library will be updated to add this functionality to dorhud if dorhud adds this functionality in future"
        )
        return false
    end

    local typeId = Idstring(assetType)
    local assetId = Idstring(assetPath)
    if DB:has(assetType, assetPath) then return true end
    DB:create_entry(typeId, assetId, assetPath)
    return true
end

---@param path string
---@return table
function DSBLT:GetFiles(path)
    if DSBLT:IsSBLT() then
        return files.GetFiles(path)
    else
        return dorhudGlobals.dorhudFileHandler.GetFiles(path)
    end
end

local function realLog(msg)
    if DSBLT:IsSBLT() then
        log(msg)
    else
        dorhud_log(msg)
    end
end

---@param msg string
function DSBLT:Log(msg)
    local callingFile = debug.getinfo(2).source:match("[^\\/]+$")
    if DSBLT.contextName ~= callingFile then
        DSBLT.contextName = callingFile
        realLog("[[ " .. callingFile .. " ]]")
    end
    realLog("\t" .. msg)
end

---@param tbl table
---@return integer
local function realTableSize(tbl)
    local i = 0
    for _, _ in next, tbl do
        i = i + 1
    end
    return i
end

---@param value any
---@return string
local function getValueString(value)
    local valueString = tostring(value)
    local valueType = type(value)

    if valueType == "string" then
        valueString = "\"" .. valueString .. "\""
    elseif valueType == "function" or valueType == "thread" then
        valueString = valueType
    elseif valueType == "userdata" and #string.gsub(valueString, "%s", "") == 0 then
        -- If value is a userdata and the userdata's toString was nothing but whitespace
        -- Return just that it was a userdata
        valueString = valueType
    end

    return valueString
end

---@param key any
---@return string
local function getKeyString(key)
    local keyString = tostring(key)
    local keyType = type(key)

    if keyType == "number" or keyType == "boolean" then keyString = "[" .. keyString .. "]"
    elseif keyType == "string" then
        if tonumber(key[1]) ~= nil or string.match(key, "%s") ~= nil then
            keyString = "[\"" .. keyString .. "\"]"
        end
    end

    return keyString
end

---@param logging table         Table to print
---@param maxRecurse integer?   If 0, recurs infinitely
---@param preface string?       Printed before printing table
---@param recurredFor integer?  Used to track how many times we've recurred
function DSBLT:LogTable(logging, maxRecurse, preface, recurredFor)
    maxRecurse = maxRecurse or 1
    recurredFor = recurredFor or 0
    local tableStylePreface = false
    local topLevel = recurredFor == 0

    if preface ~= nil then
        tableStylePreface = string.sub(preface, -1) == "{"
        self:Log(preface)
    end

    local loggingType = type(logging)

    if loggingType ~= "table" then
        error("Called LogTable on value \"" .. tostring(logging) .."\" of type \"" .. loggingType .. "\"")
        return
    end

    local nextRecurredFor = recurredFor+1
    local printPreface = string.rep("\t", recurredFor)

    if (not topLevel) or tableStylePreface then
        printPreface = printPreface .. "\t"
    end

    local loggingSize = realTableSize(logging)
    local traversedSize = 1
    for k, v in next, logging do
        local vType = type(v)
        local vSize = vType == "table" and realTableSize(v) or 0

        local keyString = getKeyString(k)
        local valueString = getValueString(v)

        local suffix = traversedSize == loggingSize and "" or ","

        -- Using recurredFor ~= maxRecurse instead of recurredFor < maxRecurse
        -- Means maxRecurse = -1 will recur infinitely, this is intentional
        if vType == "table" and vSize ~= 0 and recurredFor ~= maxRecurse then
            DSBLT:Log( printPreface .. keyString .. " = {")
            DSBLT:LogTable(v, maxRecurse, nil, nextRecurredFor)
            DSBLT:Log( printPreface .. "}" .. suffix)
        elseif vType == "table" and vSize == 0 then
            DSBLT:Log( printPreface .. keyString .. " = {}" .. suffix )
        else
            DSBLT:Log( printPreface .. keyString .. " = " .. valueString .. suffix )
        end

        traversedSize = traversedSize + 1
    end

    if tableStylePreface then
        DSBLT:Log("}")
    end
end

function DSBLT:GetModule()
    if DSBLT:IsSBLT() then
        return _G.BLT.Mods:GetModByName("DSBLT")
    else
        return dorhudGlobals.D:module("DSBLT");
    end
end

function DSBLT:Loader()
    if DSBLT:IsSBLT() then
        return _G.BLT:GetGame() .. " SuperBLT version " .. tostring(_G.BLT:GetVersion()) .. " on " .. _G.BLT:GetOS()
    else
        return "DorHUD/Dahm (What's the difference?) version " .. tostring(dorhudGlobals.D:version())
    end
end

function DSBLT:CanAddFiles()
    if DSBLT:IsSBLT() then
        return true
    else
        -- Would be nice if I could change this
        -- Not got high hopes though
        return false
    end
end

---Returns a dorhud global, only intended for internal module use
---@param name string
---@return any
function DSBLT:DorhudGlobal(name)
    if DSBLT:IsSBLT() then
        error("Attempt to retrieve dorhud global under SBLT")
    else
        if self.__dorhudGlobals[name] == nil then
            error("Attempt to get nonexistent DorHud global \"" .. name .. "\"")
        end
        return self.__dorhudGlobals[name]
    end
end

DSBLT:Log( "Completed setup for DSBLT" )
DSBLT:Log( "DSBLT is currently running under " .. DSBLT:Loader() )

DSBLT:RunRequire("nooptable")

DSBLT:RunRequire("shared/localization")

DSBLT:RunRequire("fakeDorhud/optionsMenus")
DSBLT:RunRequire("fakeDorhud/moduleOptions")
DSBLT:RunRequire("fakeDorhud/runtimehooks")
DSBLT:RunRequire("fakeDorhud/module")
DSBLT:RunRequire("fakeDorhud/dmod")
DSBLT:RunRequire("fakeDorhud/d")