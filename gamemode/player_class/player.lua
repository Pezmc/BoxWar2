AddCSLuaFile()

DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DisplayName			= "Box"

PLAYER.WalkSpeed			= 200		-- How fast to move when not running
PLAYER.RunSpeed				= 300		-- How fast to move when running
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

function PLAYER:Init() 
	util.PrecacheModel("models/hunter/plates/plate.mdl")
	self.Player:SetModel("models/hunter/plates/plate.mdl")
end

-- Called by spawn and sets loadout
function PLAYER:Loadout()
	print('Player Loadout')

	-- No weapons
    self.Player:Give( "weapon_frag" ) --Give them the Gravity Gun
    self.Player:Give( "weapon_pistol" ) --Give them the Gravity Gun
    self.Player:Give( "weapon_ar2" ) --Give them the Gravity Gun
    self.Player:Give( "weapon_357" ) --Give them the Gravity Gun
end


-- Called when player spawns with this PLAYER
function PLAYER:Spawn()
	print('Player Spawned')

	BaseClass.Spawn( self )

	self.Player:SetModel("models/hunter/plates/plate.mdl")
	self.Player:CrosshairDisable()
	self.Player:ResetHull()
	self.Player:SetAvoidPlayers(true)
	self.Player:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
	self.Player:SetColor( Color(255, 255, 255, 0))
	--self.Player:SetCustomCollisionCheck(true)
	self.Player:SetRenderMode( RENDERMODE_NONE )
	self.Player:SetupHands()

	local boxHeight = 24
	local playerHeight = 30 -- slightly higher than half
	self.Player:SetViewOffset( 	Vector( 0, 0, playerHeight ) )
	self.Player:SetViewOffsetDucked( Vector( 0, 0, playerHeight ) )

	-- Prevent 'mod_studio: MOVETYPE_FOLLOW with No Models error.'
	self.Player:DrawViewModel(false)
	
	self.Player.BWBoxEntity = ents.Create("player_box")
	self.Player.BWBoxEntity:SetAngles(self.Player:GetAngles())

	self.Player.BWBoxEntity:SetParent(self.Player)
	self.Player.BWBoxEntity:SetOwner(self.Player)

	self.Player.BWBoxEntity.health = self.Player:Health()
	self.Player.BWBoxEntity.max_health = self.Player:GetMaxHealth()

	self.Player.BWBoxEntity:Spawn()

	-- Needs to be after entity is spawned
	local boxMax = self.Player.BWBoxEntity:OBBMaxs()
	local boxMin = self.Player.BWBoxEntity:OBBMins()

	self.Player.BWBoxEntity:SetPos(self.Player:GetPos() + Vector(0, 0, -boxMin.z))

	-- Calculate new player hull slightly smaller than prop
	local scaling_factor = 0.9
	local hull_xy_max = math.floor(math.Max(boxMax.x, boxMax.y) * scaling_factor)
	local hull_xy_min = hull_xy_max * -1
	local hull_z = math.floor(boxMax.z * scaling_factor)
	
	self.Player:SetHull(Vector(hull_xy_min, hull_xy_min, 0), Vector(hull_xy_max, hull_xy_max, hull_z))
	self.Player:SetHullDuck(Vector(hull_xy_min, hull_xy_min, 0), Vector(hull_xy_max, hull_xy_max, hull_z))
end


-- Hands
function PLAYER:GetHandsModel()
	return
end

-- Register
player_manager.RegisterClass("Box", PLAYER, "player_default")