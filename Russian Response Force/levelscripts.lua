local currentMap = Global.level_data.level_id
Hooks:Add("BeardLibCreateScriptDataMods", "RRFBeardLibMapScriptHook", function()
if russianadder.isrrf <= russianadder.options[currentMap] then
			BeardLib:ReplaceScriptData("mods/Russian Response Force/revenge.generic_xml", "generic_xml", "levels/narratives/bain/revenge/world/world", "mission", true)
			BeardLib:ReplaceScriptData("mods/Russian Response Force/revenge_heli.generic_xml", "generic_xml", "levels/instances/unique/hox_estate_heli_spawn/world/world", "mission", true)
    end
end)