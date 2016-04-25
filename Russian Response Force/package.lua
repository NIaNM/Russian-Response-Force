LevelsTweakData.clone_init = LevelsTweakData.init
LevelsTweakData.LevelType = {}
LevelsTweakData.LevelType.America = "america"
LevelsTweakData.LevelType.Russia = "russia"

if not _G.russianadder then
    _G.russianadder = {}
    russianadder.mod_path = ModPath
    russianadder._data_path = SavePath .. "russianadder.txt"
    russianadder.options = {}
    russianadder.main_menu = "russianadder_menu"
end

function russianadder:Save()
    local file = io.open( self._data_path, "w+" )
    if file then
        file:write( json.encode( self.options ) )
        file:close()
    end
end

function russianadder:Load()
    local file = io.open( self._data_path, "r" )
    if file then
        self.options = json.decode( file:read("*all") )
        file:close()
    end
end

Hooks:Add( "LocalizationManagerPostInit" , "russianadderLocalization" , function( self )
    
    self:add_localized_strings( {
        [ "russianadder_menuTitle" ] = "Russian Response Force",
        [ "russianadder_menuDesc" ] = "Change the probability for Russian Response forces to replace default forces during certain heists.",
        
        [ "russianadder_never" ] = "Never",
        [ "russianadder_uncommon" ] = "Uncommon",
        [ "russianadder_common" ] = "Common",
        [ "russianadder_very_common" ] = "Very Common",
        [ "russianadder_always" ] = "Always"
    } )

    for level_id , text in pairs( russianadder.levels ) do
        self._platform = "WIN32"
        self:add_localized_strings( {
            [ "russianadder_" .. level_id ] = self:text( text ) .. ( ( string.find( tweak_data.levels[ level_id ].name_id , "2" ) and " (2)" or string.find( tweak_data.levels[ level_id ].name_id , "3" ) and " (3)" ) or "" ) or "??",
            [ "russianadderDesc_" .. level_id ] = "Change the RRF probability setting for " .. ( self:text( text ) .. ( ( string.find( tweak_data.levels[ level_id ].name_id , "2" ) and " (2)" or string.find( tweak_data.levels[ level_id ].name_id , "3" ) and " (3)" ) or "" ) or "??" )
        } )
    end

end )

Hooks:Add( "MenuManagerSetupCustomMenus" , "russianadderSetupMenu" , function( self , nodes )
    
    MenuHelper:NewMenu( russianadder.main_menu )
    
end )

Hooks:Add( "MenuManagerPopulateCustomMenus" , "russianadderCallbackFunctions" , function( self , nodes )
    
    if not russianadder or russianadder and not russianadder.levels then return end
    
    for level_id , _ in pairs( russianadder.levels ) do
    
        MenuCallbackHandler[ "russianadderClbk_" .. level_id ] = function( self, item )
        
            russianadder.options[ level_id ] = item:value()
            russianadder:Save()
            
        end
    
        MenuHelper:AddMultipleChoice( {
        
            id             = "russianadderID_" .. level_id,
            title         = "russianadder_" .. level_id,
            desc         = "russianadderDesc_" .. level_id,
            callback     = "russianadderClbk_" .. level_id,
            items         = {
                            "russianadder_never",
                            "russianadder_uncommon",
                            "russianadder_common",
                            "russianadder_very_common",
                            "russianadder_always"
                          },
            menu_id     = russianadder.main_menu,
            value         = russianadder.options[ level_id ]
            
        } )
        
    end

end )

Hooks:Add( "MenuManagerBuildCustomMenus" , "russianadderBuildMenu" , function( self , nodes )

    nodes[ russianadder.main_menu ] = MenuHelper:BuildMenu( russianadder.main_menu )
    MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu , russianadder.main_menu , "russianadder_menuTitle" , "russianadder_menuDesc" )
    
end )

russianadder.dofiles = {
    
}

russianadder.hook_files = {
    ["lib/managers/localizationmanager"] = "LocalizationManager.lua"
}

if not russianadder.setup then
    russianadder:Load()
    if russianadder.options.russianadder_enabled == nil then 
        russianadder.options.russianadder_enabled = true
        russianadder:Save()
    end
    russianadder:Load()
    for p, d in pairs(russianadder.dofiles) do
        dofile(ModPath .. d)
    end
    russianadder.setup = true
    log("[RRF] Loaded options")
end

if RequiredScript then
    local requiredScript = RequiredScript:lower()
    if russianadder.hook_files[requiredScript] then
        dofile( ModPath .. russianadder.hook_files[requiredScript] )
    end
end

function LevelsTweakData:init()
    self:clone_init()
    
    russianadder.isrrf = math.random(1, 4)
    russianadder:Load()
    russianadder.levels = {}
    
    for _, level in ipairs(self._level_index) do
        if type(self[level].package) ~= "table" then 
            local temp = self[level].package
            self[level].package = {temp}
        end
        table.insert(self[level].package, "packages/lvl_mad")
    end
    
    for  _, level_id in ipairs(self._level_index) do
        if self[ level_id ].name_id then
            russianadder.levels[ level_id ] = self[ level_id ].name_id
        end
    end
    
    for _ , level_id in pairs( self._level_index ) do
        if russianadder and russianadder.options and russianadder.options[ level_id ] and russianadder.options[ level_id ] ~= nil then
            if russianadder.isrrf <= russianadder.options[level_id] then
                self[level_id].ai_group_type = self.LevelType.Russia
            end
        end
    end
    log("[RRF] Russian presence initialized")
end

PackageManager:load("levels/narratives/elephant/mad/world_sounds")