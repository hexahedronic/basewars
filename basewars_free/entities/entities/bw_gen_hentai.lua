AddCSLuaFile()

ENT.Base 			= "bw_base_generator"
ENT.PrintName 		= "Hentai Generator"

ENT.Model 			= "models/props_junk/garbage_newspaper001a.mdl"

ENT.PowerGenerated 	= 0
ENT.PowerGenerated2 = 6
ENT.PowerCapacity 	= 500

ENT.TransmitRadius 	= 300
ENT.TransmitRate 	= 6

ENT.Sounds 			= {Sound("physics/flesh/flesh_squishy_impact_hard1.wav"), Sound("physics/flesh/flesh_squishy_impact_hard2.wav"), Sound("physics/flesh/flesh_squishy_impact_hard3.wav"), Sound("physics/flesh/flesh_squishy_impact_hard4.wav")}
ENT.Color			= Color(255, 0, 255, 255)

function ENT:Init()

	self:SetColor(self.Color)
	
end

function ENT:UseFunc()

	self:EmitSound(self.Sounds[math.random(1, #self.Sounds)])
	self:ReceivePower(self.PowerGenerated2)
	
end
