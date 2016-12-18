AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.Type 		= "anim"
ENT.PrintName 	= "Battery Upgrade Kit"

ENT.Model 		= "models/props_junk/cardboard_box004a.mdl"

ENT.PowerAmt	= 2

if CLIENT then return end

function ENT:SpawnFunction(ply, tr, class)

	local pos = ply:GetPos()
	
	local ent = ents.Create(class)
		ent:CPPISetOwner(ply)
		ent:SetPos(pos + ply:GetForward() * 32)
	ent:Spawn()
	ent:Activate()
	
	local phys = ent:GetPhysicsObject()
	
	if IsValid(phys) then

		phys:Wake()

	end	
	
	return ent

end

function ENT:Initialize()

	self.BaseClass:Initialize()

	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:PhysWake()

	self:Activate()
	
end

function ENT:PhysicsCollide(data, phys)

	self.BaseClass:PhysicsCollide(data, phys)

	local ent = data.HitEntity
	if not BaseWars.Ents:Valid(ent) then return end
	
	if ent.Battery then return end
	
	if ent.GetMaxPower and not self.Removing then
	
		ent.Battery = true
	
		ent:SetMaxPower(ent:GetMaxPower() * self.PowerAmt)
		
		self.Removing = true
		self:Remove()
		
	return end

end
