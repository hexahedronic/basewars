ENT.Base = "bw_base_drink"
ENT.HealAmount = 0
ENT.Random = true

ENT.Model = "models/props_junk/PopCan01a.mdl"

ENT.Effects = {
	"DoubleJump",
	"Steroid",
	"Adrenaline",
	"Rage",
	"Regen",
	"Shield",
}

function ENT:SetupDataTables()

	self:NetworkVar("String", 0, "DrugEffect")
	
	self:NetworkVar("Int", 2, "DrugDuration")

end

if SERVER then

	AddCSLuaFile()

	function ENT:Init()
		
		if self.Random then

			self:SetSkin(math.random(0, 2))

			self:SetDrugEffect(self.Effects[math.random(1, #self.Effects)])
			
		end
		
		self:SetDrugDuration(0)

	end
	
	function ENT:OnDrink(ply)
	
		local Duration = self:GetDrugDuration()
		if Duration < 1 then Duration = nil end
	
		ply:ApplyDrug(self:GetDrugEffect(), Duration)
	
	end

end
