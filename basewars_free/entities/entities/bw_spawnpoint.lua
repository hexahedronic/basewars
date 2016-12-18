ENT.Base = "bw_base_electronics"
ENT.Type = "anim"

ENT.PrintName = "SpawnPoint"
ENT.Model = "models/props_trainstation/trainstation_clock001.mdl"

ENT.PowerRequired = 1
ENT.PowerCapacity = 5000

ENT.AllwaysRaidable = true

if SERVER then

	AddCSLuaFile()

	local ForceAngle = Angle(-90, 0, 0)
	function ENT:Init()

		self:SetAngles(ForceAngle)
		
	end
	
	function ENT:SpawnFunction(ply, tr, class)
	
		local pos = ply:GetPos()
		
		local ent = ents.Create(class)
			ent:CPPISetOwner(ply)
			ent:SetPos(pos)
			ply:SetPos(pos + Vector(0,0,3))
		ent:Spawn()
		ent:Activate()
		
		local phys = ent:GetPhysicsObject()
		
		if IsValid(phys) then

			phys:EnableMotion(false)

		end	
		
		return ent
	
	end
	
	function ENT:CheckUsable()

		if BaseWars.Ents:ValidPlayer(self.OwningPly) then return false end
		
	end

	function ENT:UseFunc(activator, caller, usetype, value)

		if not BaseWars.Ents:ValidPlayer(self.OwningPly) then self.OwningPly = nil end
	
		local ply = activator:IsPlayer() and activator or caller:IsPlayer() and caller or nil

		if ply then
		
			self:EmitSound("buttons/blip1.wav")
			
			if BaseWars.Ents:Valid(ply.SpawnPoint) then
				
				ply.SpawnPoint.OwningPly = false
				ply.SpawnPoint:EmitSound("ambient/machines/thumper_shutdown1.wav")
				
			end
			
			self.OwningPly = ply
			ply.SpawnPoint = self
			
			ply:Notify(BaseWars.LANG.NewSpawnPoint, BASEWARS_NOTIFICATION_GENRL)
			
		return end
		
		self:EmitSound("buttons/button10.wav")
		
	end

	function ENT:OnRemove()

		if BaseWars.Ents:ValidOwner(self.OwningPly) then
		
			self.OwningPly.SpawnPoint = nil
			
		end
		
	end

end
