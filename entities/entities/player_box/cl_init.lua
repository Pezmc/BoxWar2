include("shared.lua")

-- Called every frame
function ENT:Draw(flag)
	local OtherPlayersProp = self:GetOwner() != LocalPlayer() 
	if (OtherPlayersProp) then
		self.Entity:DrawModel()
		self.Entity:DrawShadow(true)
	else
		self.Entity:DrawShadow(false)
	end
end 

