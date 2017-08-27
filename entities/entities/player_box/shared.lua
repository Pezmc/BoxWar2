ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:BWRemove()
	if (self:IsValid()) then
		self:Remove()
	end
end