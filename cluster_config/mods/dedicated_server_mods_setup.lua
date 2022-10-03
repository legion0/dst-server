--There are two functions that will install mods, ServerModSetup and ServerModCollectionSetup. Put the calls to the functions in this file and they will be executed on boot.

--ServerModSetup takes a string of a specific mod's Workshop id. It will download and install the mod to your mod directory on boot.
        --The Workshop id can be found at the end of the url to the mod's Workshop page.
        --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=350811795
        --ServerModSetup("350811795")

--ServerModCollectionSetup takes a string of a specific mod's Workshop id. It will download all the mods in the collection and install them to the mod directory on boot.
        --The Workshop id can be found at the end of the url to the collection's Workshop page.
        --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=379114180
        --ServerModCollectionSetup("379114180")

ServerModSetup("378160973") -- Global Positions
ServerModSetup("569043634") -- Campfire Respawn
ServerModSetup("666155465") -- Show Me (Origin)
ServerModSetup("375859599") -- Health Info
ServerModSetup("374550642") -- Increased Stack size
ServerModSetup("362175979") -- Wormhole Marks [DST]
ServerModSetup("1582457351") -- Backpack slot
ServerModSetup("396026892") -- Large Chest
