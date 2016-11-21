AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Electricals"

ENT.Model = "models/props_c17/metalPot002a.mdl"
ENT.Skin = 0

ENT.IsElectronic = true
ENT.PowerRequired = 5
ENT.PowerCapacity = 1000

function ENT:DrainPower(val)

	if not self:IsPowered(val) then return false end

	self:SetPower(self:GetPower() - (val or self.PowerRequired))

	return true

end

function ENT:IsPowered(val)

	return self:GetPower() >= (val or self.PowerRequired)

end

if SERVER then

	function ENT:Think()

		self:ThinkFuncBypass()

		if self:IsPowered() and self:BadlyDamaged() and math.random(0, 11) == 0 then

			self:Spark()

		end

		if self:WaterLevel() > 0 and not self:GetWaterProof() then

			if not self.FirstTime and self:Health() > 25 then

				self:SetHealth(25)
				self:Spark()

				self.FirstTime = true

			end

			if self.rtb == 2 then

				self.rtb = 0
				self:TakeDamage(1)

			else

				self.rtb = self.rtb + 1

			end

		else

			self.FirstTime = false

		end

		if not self:DrainPower() or self:BadlyDamaged() then

			if self:GetUsable() then self:SetUsable(false) end

		return end

		local Res = self:CheckUsable()
		local State = Res ~= false

		if State ~= self:GetUsable() then

			self:SetUsable(State)

		end

		self:ThinkFunc()

	end

	function ENT:CheckUsable()



	end

	function ENT:Use(activator, caller, usetype, value)

		self:UseFuncBypass(activator, caller, usetype, value)

		if not self:GetUsable() then return end
		if self:CheckUsable() == false then return end

		if not self:IsPowered() or self:BadlyDamaged() then

			self:EmitSound("buttons/button10.wav")

		return end

		self:UseFunc(activator, caller, usetype, value)

	end

end
