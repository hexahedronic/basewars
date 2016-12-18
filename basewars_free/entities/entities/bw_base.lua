AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Base Entity"

ENT.Model = "models/props_interiors/pot02a.mdl"
ENT.Skin = 0

ENT.PresetMaxHealth = 100

function ENT:Init()

end

function ENT:ThinkFunc()

end

function ENT:ThinkFuncBypass()

end

function ENT:UseFunc()

end

function ENT:UseFuncBypass()

end

function ENT:StableNetwork()

end

function ENT:BadlyDamaged()

	return self:Health() <= (self:GetMaxHealth() / 5)

end

function ENT:SetupDataTables()

	self:NetworkVar("Bool", 0, "WaterProof")
	self:NetworkVar("Bool", 1, "Usable")
	
	self:NetworkVar("Int", 0, "Power")
	self:NetworkVar("Int", 1, "MaxPower")
	
	self:StableNetwork()
	
end

function ENT:DrainPower(val)

	local Value = self:GetPower() - val

	if Value > self:GetMaxPower() then val = self:GetMaxPower() end
	if Value < 0 then val = 0 end

	self:SetPower(self:GetPower() - val)
	
end

function ENT:ReceivePower(val)

	local Value = self:GetPower() + val

	if Value > self:GetMaxPower() then Value = self:GetMaxPower() end
	if Value < 0 then val = 0 end

	return self:SetPower(Value)

end


if SERVER then

	function ENT:Initialize()

		self:SetModel(self.Model)
		self:SetSkin(self.Skin)

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

		self:SetUseType(SIMPLE_USE)
		self:AddEffects(EF_ITEM_BLINK)
		
		self:PhysWake()
		self:Activate()
		
		self:SetHealth(self.PresetMaxHealth)
		self:SetMaxPower(self.PowerCapacity)
		
		self.rtb = 0
		
		self:SetUsable(true)
		self:SetWaterProof(BaseWars.Config.Ents.Electronics.WaterProof)
		
		self:Init()
		
		self:SetMaxHealth(self:Health())

	end
	
	function ENT:Repair()
	
		self:SetHealth(self:GetMaxHealth())
		
	end

	function ENT:Spark(a, ply)

		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin(vPoint)
		util.Effect(a or "ManhackSparks", effectdata)
		self:EmitSound("DoSpark")

		if ply and ply:GetPos():Distance(self:GetPos()) < 80 and math.random(0, 10) == 0 then

			local d = DamageInfo()

			d:SetAttacker(ply)
			d:SetInflictor(ply)
			d:SetDamage(ply:Health() / 2)
			d:SetDamageType(DMG_SHOCK)

			local vPoint = ply:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin(vPoint)
			util.Effect(a or "ManhackSparks", effectdata)

			ply:TakeDamageInfo(d)

		end

	end

	function ENT:OnTakeDamage(dmginfo)

		local dmg = dmginfo:GetDamage()
		local Attacker = dmginfo:GetAttacker()

		self:SetHealth(self:Health() - dmg)

		if self:Health() <= 0 and not self.BlownUp then
			
			self.BlownUp = true
		
			BaseWars.UTIL.PayOut(self, Attacker)
		
			if dmginfo:IsExplosionDamage() then
			
				self:Explode(false)

			return end

			self:Explode()

		return end

		self:Spark(nil, Attacker)

	end

	function ENT:Explode(e)

		if e == false then

			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin(vPoint)
			util.Effect("Explosion", effectdata)

			self:Remove()
			
		return end

		local ex = ents.Create("env_explosion")
			ex:SetPos(self:GetPos())
		ex:Spawn()
		ex:Activate()
		
		ex:SetKeyValue("iMagnitude", 100)
		
		ex:Fire("explode")

		self:Spark("cball_bounce")
		self:Remove()

		SafeRemoveEntityDelayed(ex, 0.1)

	end
	
end
