ENT.Base = "bw_base_electronics"
ENT.Type = "anim"

ENT.PrintName = "Radar Transmitter"
ENT.Model = "models/props_rooftop/roof_dish001.mdl"

ENT.PowerRequired = 20
ENT.PowerCapacity = 5000

ENT.AllwaysRaidable = true

if SERVER then

	AddCSLuaFile()

	function ENT:SetMinimap(ply, bool)

		ply:SetNW2Bool("BaseWars_HasRadar", bool)

	end

	function ENT:ThinkFuncBypass()

		local Owner = BaseWars.Ents:ValidOwner(self)
		if Owner then

			self:SetMinimap(Owner, self:IsPowered())

		end

	end

	function ENT:OnRemove()

		local Owner = BaseWars.Ents:ValidOwner(self)
		if Owner then

			self:SetMinimap(Owner, false)

		end

	end

end
