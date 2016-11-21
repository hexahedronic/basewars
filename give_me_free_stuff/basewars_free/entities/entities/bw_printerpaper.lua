AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.Type 		= "anim"
ENT.PrintName 	= "Printer Paper"

ENT.Model 		= "models/props_lab/clipboard.mdl"

ENT.PaperAmount = 1000

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
	if not ent or not IsValid(ent) then return end
	
	if ent.MaxPaper and not self.Removing then
	
		ent:AddPaper(self.PaperAmount)
		
		self.Removing = true
		self:Remove()
		
	end

end
