AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Generator"

ENT.Model = "models/props_wasteland/laundry_washer003.mdl"
ENT.Skin = 0

ENT.IsGenerator = true

ENT.PowerGenerated = 15
ENT.PowerCapacity = 1000
ENT.TransmitRadius = 600
ENT.TransmitRate = 20

function ENT:TransmitPower()

	local Ents = ents.FindInSphere(self:GetPos(), self.TransmitRadius)

	for k, v in next, Ents do
	
		if not v or not IsValid(v) or v == self then continue end
		if not v.IsElectronic or not v.ReceivePower then continue end
		
		local Pow = v.GetPower and v:GetPower() or 0
		local Max = v.GetMaxPower and v:GetMaxPower() or 0
		
		if Max < 1 then continue end
		
		if Pow >= Max then continue end
		
		local Transmit = math.min(self.TransmitRate, self:GetPower())
		Transmit = math.min(Transmit, (Max - Pow))
		
		v:ReceivePower(Transmit)
		
		local Drain = Transmit - (PowerNotUsed or 0)
		self:DrainPower(Drain)
		
	end
	
end


if SERVER then

	function ENT:Think()
	
		if not self:BadlyDamaged() then
		
			self:ReceivePower(self.PowerGenerated)
			
		end
		
		self:TransmitPower()

		if self:BadlyDamaged() and math.random(0, 11) == 0 then
			
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
		
		if self:BadlyDamaged() then return end

		self:ThinkFunc()

	end
	
end
