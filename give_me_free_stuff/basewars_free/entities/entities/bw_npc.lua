AddCSLuaFile()

ENT.Base 		= "base_anim"
ENT.Type 		= "anim"

ENT.PrintName 	= "Help and Info"

ENT.Model 		= "models/Humans/Group03m/male_09.mdl"

ENT.Offset 		= Vector(0, 0, -3)
ENT.Offset2		= Vector(0, 0, 4)

ENT.TextColor	= Color(0, 150, 255, 255)
ENT.IsBWNPC		= true

ENT.AutomaticFrameAdvance = true

if CLIENT then return end

ENT.UsedTime 	= CurTime()

function ENT:OnUse(ply, caller)

	net.Start("BaseWars.NPCs.Menu")
		net.WriteEntity(self)
	net.Send(ply)

end

function ENT:AcceptInput(Name, ply, caller)

	if Name == "Use" and ply:IsPlayer() and CurTime() - 1 > self.UsedTime then

		self:OnUse(ply, caller)
		self.UsedTime = CurTime()

	return end

end

function ENT:Initialize()

	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_BBOX)
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(USE_SIMPLE)

	self.IDLESequence = 17--self:LookupSequence("idle_angry")

	self:Activate()

	timer.Simple(0, function() self:FixPosition() end)

end

function ENT:FixPosition()

	self:SetPos(self:GetPos() + self.Offset2)

	self:DropToFloor()
	self:SetPos(self:GetPos() + self.Offset)

	local Ang = self:GetAngles()
	Ang.r = 0
	Ang.p = 0

	self:SetAngles(Ang)

	local Phys = self:GetPhysicsObject()

	if BaseWars.Ents:Valid(Phys) then Phys:Sleep() end

	self:Activate()

end

function ENT:Think()

	if not self.IDLESequence then return end

    self:SetSequence(self.IDLESequence)

	local Time = CurTime() + self:SequenceDuration(self.IDLESequence)
	self:NextThink(Time)

	return true

end
