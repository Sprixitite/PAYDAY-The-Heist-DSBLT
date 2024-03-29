# DSBLT

Dorhud -> SuperBLT compatibility mod, emulates a DorHUD environment so mods built for DorHUD can (attempt) to run on the SuperBLT hook for PD:TH

## NOT BY ANY MEANS COMPLETE
Tested only on very simple mods so far, this converter has successfully converted both [PD:TH CustomFOV](https://modworkshop.net/mod/23094), and [Doom Viewmodel](https://modworkshop.net/mod/28062) with the help of [the associated `mod.txt` generator](https://github.com/Sprixitite/ThatDahmModConverter) to run under SuperBLT rather than DorHUD.

# Usage

## Mod Developer:
DSBLT is intended to be used in one of the following ways:
1) Updating existing DorHUD mods with little effort
2) Target DSBLT as your mod framework, which implements a subset of both DorHUD and SuperBLT's capabilities such that your mod is tied to neither loader

If targeting DSBLT (I wouldn't recommend this at the moment, it's untested), reference `commonbase.lua` for the currently implemented features.

If updating an existing mod, attempt to generate a `mod.txt` using [the generator](https://github.com/Sprixitite/ThatDahmModConverter) also found on my github profile, if the generator works, place the newly generated `mod.txt` into the mod folder and attempt to run PD:TH with the mod installed to test it's functionality.

If the [`mod.txt` generator](https://github.com/Sprixitite/ThatDahmModConverter) doesn't function, please file an issue on that repo's page with a link to the mod and I'll try to get back to you ASAP/

## End User:
- Needed to run DorHUD mods under SuperBLT
- Needed to run mods which target DSBLT
- Throw it in your mods folder, should work just fine