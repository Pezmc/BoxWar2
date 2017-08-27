AddCSLuaFile()

local meta = FindMetaTable("Player")
if !meta then return end

-- Removes the prop given to the player
function meta:BWRemoveBox()
	if CLIENT || !self:IsValid() then return end
	
	if self.BWBoxEntity then
		self.BWBoxEntity:BWRemove()
	end
end

function meta:BWKill()
	if CLIENT || !self:IsValid() then
		return
	end

	-- Create an invisible model to copy
    local invisibleDoll = ents.Create("prop_physics")
    invisibleDoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
    invisibleDoll:SetModel("models/Humans/Group01/Male_05.mdl")
    invisibleDoll:SetAngles( self:GetAngles() )
    invisibleDoll:SetPos( self:GetPos() )
    invisibleDoll:SetColor( Color(0, 0, 0, 0) ) 
    invisibleDoll:Spawn()

    -- Set the invisible model to crouch
    sequence = invisibleDoll:LookupSequence("roofidle1")
	invisibleDoll:SetPlaybackRate( 1.0 )
	invisibleDoll:SetSequence(sequence)
	invisibleDoll:ResetSequence( sequence )
	invisibleDoll:SetCycle( 1 )
    
    -- Attempt to grab players model
	local cl_playermodel = self:GetInfo( "cl_playermodel" )
    local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
    if (modelname == nil) then
    	modelname = "models/Humans/Group01/Male_05.mdl"
  	end
 	util.PrecacheModel( modelname )

    -- Spawn a ragdoll for the player
    local doll = ents.Create("prop_ragdoll")
    --doll:SetParent( invisibleDoll )
    doll:AddEffects( EF_BONEMERGE )
	doll:SetModel( modelname )
    doll:SetPos( invisibleDoll:GetPos() )
    doll:SetAngles( invisibleDoll:GetAngles() )
    doll:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
    doll:Spawn()	
   	doll:Activate()
	doll.OwnerINT = self:EntIndex()
	doll.PhysgunPickup = false
	doll.Owner = ply      

	-- position the bones
   local num = doll:GetPhysicsObjectCount() - 1
   local v = self:GetVelocity() / 2

   for i=0, num do
      local bone = doll:GetPhysicsObjectNum(i)
      if IsValid(bone) then
         local bp, ba = invisibleDoll:GetBonePosition(doll:TranslatePhysBoneToBone(i))
         if bp and ba then
            bone:SetPos(bp)
            bone:SetAngles(ba)
         end

         bone:SetVelocity(v)
      end
    end
    
    invisibleDoll:Remove()
    
    -- Smash the box
	self.BWBoxEntity:BWSmash(v)
	
	-- Safely remove the doll after 60 seconds
    SafeRemoveEntityDelayed(doll, 60)
    
    -- Human blood
	DecalName = "Blood" 
	EffectName = "BloodImpact"
	
	-- Perform a trace from the player down towards the ground
	local Trace = {}
	Trace.start = self:GetPos()
	Trace.endpos = Trace.start - Vector(0,0,500);
	Trace.filter = self.BWBoxEntity
	local tr = util.TraceLine( Trace )
			
	-- If we hit something
	if ( tr.Hit && tr.HitPos:Distance( self:GetPos() ) < 50 ) then
	
		-- Spawn some blood
		util.Decal( DecalName, tr.HitPos + tr.HitNormal + Vector(0.2, 0.2, 0) * math.random(0,100),
							   tr.HitPos - tr.HitNormal - Vector(0.2, 0.2, 0) * math.random(0,100))
		util.Decal( DecalName, tr.HitPos - tr.HitNormal - Vector(0.2, 0.2, 0) * math.random(0,100),
							   tr.HitPos + tr.HitNormal + Vector(0.2, 0.2, 0) * math.random(0,100))
		util.Decal( DecalName, tr.HitPos - tr.HitNormal - Vector(0.2, 0.2, 0) * math.random(0,100),
							   tr.HitPos - tr.HitNormal - Vector(0.2, 0.2, 0) * math.random(0,100))
		util.Decal( DecalName, tr.HitPos + tr.HitNormal + Vector(0.2, 0.2, 0) * math.random(0,100),
							   tr.HitPos + tr.HitNormal + Vector(0.2, 0.2, 0) * math.random(0,100))
							   
		-- Then show a blood "explosion"
		local Effect = EffectData()
		Effect:SetOrigin( tr.HitPos )
		util.Effect( EffectName, Effect )
		Effect = EffectData()
		Effect:SetOrigin( self:GetPos() )
		util.Effect( EffectName, Effect )
	end
end