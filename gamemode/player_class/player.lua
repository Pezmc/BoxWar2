AddCSLuaFile()

DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DisplayName			= "Box"

PLAYER.WalkSpeed			= 400		-- How fast to move when not running
PLAYER.RunSpeed				= 600		-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.3		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 200		-- How powerful our jump should be
PLAYER.CanUseFlashlight		= true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= true		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands

-- Prevent 'mod_studio: MOVETYPE_FOLLOW with No Models error.'
PLAYER.DrawViewModel		= false

-- Called by spawn and sets loadout
function PLAYER:Loadout()
	print('Player Loadout')

	-- No weapons
    self.Player:Give( "weapon_physcannon" ) --Give them the Gravity Gun
end


-- Called when player spawns with this PLAYER
function PLAYER:Spawn()
	print('Player Spawned')

	BaseClass.Spawn( self )

	self.Player:CrosshairDisable()
	self.Player:ResetHull()
	self.Player:SetAvoidPlayers(true)
	self.Player:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	self.Player:SetColor( Color(255, 255, 255, 0))
	self.Player:SetCustomCollisionCheck(true)
	self.Player:SetRenderMode( RENDERMODE_NONE )
	self.Player:SetupHands()
	
	-- Prevent 'mod_studio: MOVETYPE_FOLLOW with No Models error.'
	self.Player:DrawViewModel(false)
	
	self.Player.BWBoxEntity = ents.Create("player_box")
	self.Player.BWBoxEntity:SetPos(self.Player:GetPos())
	self.Player.BWBoxEntity:SetAngles(self.Player:GetAngles())
	self.Player.BWBoxEntity:Spawn()
	self.Player.BWBoxEntity:SetSolid(SOLID_BBOX)
	self.Player.BWBoxEntity:SetParent(pl)
	self.Player.BWBoxEntity:SetOwner(pl)

	self.Player.BWBoxEntity.max_health = self.Player:GetMaxHealth()
end


-- Hands
function PLAYER:GetHandsModel()
	return
end


-- Called when a player dies with this PLAYER
--function PLAYER:OnDeath(pl, attacker, dmginfo)
--	self.Player:RemoveProp()
--	self.Player:RemoveClientProp()
--end

-- Register
player_manager.RegisterClass("Box", PLAYER, "player_default")