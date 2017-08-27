-- List all files for the client
AddCSLuaFile( "cl_init.lua" )

AddCSLuaFile( "sh_init.lua" )

AddCSLuaFile( "player_class/player.lua" )

-- Include server only files
include( "sv_init.lua" )