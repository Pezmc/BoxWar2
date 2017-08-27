AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- Called when the entity initializes
function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate001a.mdl")
	self:PrecacheGibs()

	self:SetSolid(SOLID_BBOX)
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

	self.Entity:SetMoveType( MOVETYPE_NONE )
end

-- Called when we take damge
function ENT:OnTakeDamage(dmg)
	local pl = self:GetOwner()
	local attacker = dmg:GetAttacker()
	local inflictor = dmg:GetInflictor()

	if pl && pl:IsValid() && pl:Alive() && pl:IsPlayer() && attacker:IsPlayer() && dmg:GetDamage() > 0 then
		self.health = self.health - dmg:GetDamage()
		pl:SetHealth(self.health)
		
		if self.health <= 0 then
			pl:KillSilent()
			
			MsgAll(attacker:Name() .. " found and killed " .. pl:Name() .. "\n") 
			
			attacker:AddFrags(1)
			pl:AddDeaths(1)
			attacker:SetHealth(math.Clamp(attacker:Health() + 25, 1, 100))

			pl:BWKill()
		end
	end
end

function ENT:BWSmash(velocity)
	if (self:IsValid()) then
		self:GibBreakClient(velocity)
		self:Remove()
	end
end