DSBLT.localization = DSBLT.localization or {
    pendingStrings = {}
}

-- There are more locales but these are the ones dorhud seems to support
-- Obtained by printing out every localization file within SBLT
local localeMappings = {
    ["en"] = "english",
    ["fr"] = "french",
    ["ru"] = "russian",
    ["it"] = "italian",
    ["es"] = "spanish",
    ["de"] = "german",
    ["ko"] = "korean"
    --[[
        Simplified/traditional chinese?
    ["chs"] = "???"
    ["cht"] = "???"

    ["cs"] = "???"
    ["id"] = "???"

        Japanese
    ["ja"] = "???"

    ["nl"] = "???"
    ["pl"] = "???"

        Brazilian portugese?
    ["pt-br"] = "???"

    ["sv"] = "???"
    ["tr"] = "???"
    ]]--
}

local localizationModule = DSBLT.localization
local locManager = DSBLT:HookClass("LocalizationManager")

function localizationModule:CurrentLanguage()
    if DSBLT:IsSBLT() then
        local bltLang = _G.BLT.Localization:get_language().language
        if localeMappings[bltLang] == nil then
            DSBLT:Log("BLT Localization module returned locale \"" .. bltLang .. "\" not found in localeMappings")
        end
        return localeMappings[bltLang] or bltLang
    else
        return DSBLT:DorhudGlobal("DLocalizer"):system_language(true, true)
    end
end

function localizationModule:AddLocString(id, strings, ...)
    local varargs = {...}
    if #varargs > 0 then
        DSBLT:Log("DSBLT:AddLocString called with unexpected arguments for id \"" .. tostring(id) .. "\"! Args are as follows:")
        for i, v in next, varargs do
            DSBLT:Log(tostring(i) .. " - " .. type(v) .. " \"" .. tostring(v) .. "\"")
        end
    end
    
    if not DSBLT:HookedClassExists(locManager) then
        self.pendingStrings[id] = strings
        return
    end

    local lang = localizationModule:CurrentLanguage()
    DSBLT:Log("Adding localization entry for ID \"" .. id .. "\" with locale \"" .. lang .. "\"")
    if strings[lang] == nil then
        DSBLT:Log("No entry for locale found, printing available locales...")
        for locale, _ in next, strings do
            DSBLT:Log(locale)
        end
    end

    if DSBLT:IsSBLT() then
        DSBLT:GetClass(locManager):add_localized_strings({
            [id] = strings[lang] or strings["english"]
        })
    else
        DSBLT:DorhudGlobal("DMod"):add_localization_string(id, strings)
    end
end

if not DSBLT:HookedClassExists(locManager) then return end

DSBLT:PostHook(locManager, "init", "LocalizationManagerPostInit_DSBLT", function()
    DSBLT:Log("Localization manager just got real, adding " .. tostring(#localizationModule.pendingStrings) .. " pending loc strings...")
    for id, strings in next, localizationModule.pendingStrings do
        DSBLT:Log("Adding string for ID " .. id)
        localizationModule:AddLocString(id, strings)
    end
    DSBLT:Log("Current locale is \"" .. tostring(localizationModule:CurrentLanguage()) .. "\"")
end)