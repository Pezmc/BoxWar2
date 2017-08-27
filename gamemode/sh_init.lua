GM.Name = "BoxWar"
GM.Author = "Pez Cuckow & Oliver Brown"
GM.Email = "N/A"
GM.Website = "N/A"

TEAM_BOX = 1

function GM:Initialize()
	MsgN("BoxWar gamemode initializing...")
end

-- Called on gamemode init
function GM:CreateTeams()
	print("Create teams")
	team.SetUp(TEAM_BOX, "Box", Color(255, 60, 60, 255))
	team.SetSpawnPoint(TEAM_BOX, {"info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"})
	team.SetClass(TEAM_BOX, { "Box" })
end