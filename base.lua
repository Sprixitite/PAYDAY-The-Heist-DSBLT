local module = DMod:new("DSBLT", {
    abbr = "DSBLT",
	version = "1.0",
	author = "Sprixitite",
	description = "DorHud-SuperBLT Compatibility Mod",
})

module:register_include("commonbase")

module:hook_post_require("lib/managers/localizationmanager", "shared/localization.lua")

return module