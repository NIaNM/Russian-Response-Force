Hooks:PostHook( LocalizationManager , "init" , "russianadderLocaizationHook" , function( self )

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
            [ "russianadderDesc_" .. level_id ] = "Change the time setting for " .. ( self:text( text ) .. ( ( string.find( tweak_data.levels[ level_id ].name_id , "2" ) and " (2)" or string.find( tweak_data.levels[ level_id ].name_id , "3" ) and " (3)" ) or "" ) or "??" )
        } )
    end

end )