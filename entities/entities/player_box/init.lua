AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- Called when the entity initializes
function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate001a.mdl")

	self.health = 100

	self.Entity:SetMoveType(MOVETYPE_NONE)
end

-- Called when we take damge
function ENT:OnTakeDamage(dmg)
	local pl = self:GetOwner()
	local attacker = dmg:GetAttacker()
	local inflictor = dmg:GetInflictor()

	print('Entity box took damage')
end