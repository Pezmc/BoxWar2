include( "sh_init.lua" )

include( "sh_player.lua" )

include( "player_class/player.lua" )

local function PlayerInitialSpawn(pl)
	MsgN("MsgN: Player init spawn")
	print("Print: Player init spawn")

	pl:SetTeam(TEAM_BOX)

	PrintMessage(HUD_PRINTCONSOLE, pl:GetClassID())
	PrintMessage(HUD_PRINTCONSOLE, pl:Team())
end

hook.Add( "PlayerInitialSpawn", "bw_on_first_spawn", PlayerInitialSpawn)

local function PlayerSpawn(pl) 
	MsgN("MsgN: Player spawn")

	player_manager.SetPlayerClass( pl, "Box" )
end
hook.Add( "PlayerSpawn", "bw_on_spawn", PlayerSpawn)

-- Prevent gmod handling player death
function  GM:DoPlayerDeath( ply, attacker, dmginfo )
 	-- DO nothing
end