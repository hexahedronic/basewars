AddCSLuaFile()

ENT.Base 				= "bw_base_electronics"
ENT.Type 				= "anim"

ENT.PrintName 			= "Armour Dispenser"
ENT.Author 				= "Q2F2"

ENT.Model 				= "models/props_combine/suit_charger001.mdl"
ENT.Sound				= Sound("HL1/fvox/blip.wav")

function ENT:Init()

	self:SetModel(self.Model)
	self:SetHealth(500)
	
	self:SetUseType(CONTINUOUS_USE)
	
end

function ENT:CheckUsable()

	if self.Time and self.Time + BaseWars.Config.DispenserTime > CurTime() then return false end
	
end

function ENT:UseFunc(ply)
	
	if not BaseWars.Ents:ValidPlayer(ply) then return end
	
	self.Time = CurTime()
	
	local Armor = ply:Armor()
	if Armor >= 100 then return end
	
	ply:SetArmor(Armor + 10)
	self:EmitSound(self.Sound, 100, 60)
	
	if ply:Armor() > 100 then ply:SetArmor(100) end
	
end
