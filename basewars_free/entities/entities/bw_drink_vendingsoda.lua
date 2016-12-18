ENT.Base = "bw_base_drink"
ENT.HealAmount = 20
ENT.Random = false

ENT.Model = "models/props_junk/PopCan01a.mdl"

if SERVER then

	AddCSLuaFile()

	function ENT:Init()

		if self.Random then

			self:SetSkin(math.random(0, 2))

		end

	end

end
