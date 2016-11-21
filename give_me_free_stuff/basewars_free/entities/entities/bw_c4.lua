AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Model = "models/weapons/w_c4_planted.mdl"
ENT.ExplodeTime = 20
ENT.ExplodeRadius = 200
ENT.ShowTimer = true

ENT.Counter = 0
ENT.RealCounter = 0

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if SERVER then

	function ENT:Initialize()

		self:SetModel(self.Model)
		self:SetUseType(CONTINUOUS_USE)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)

		self.CountingDown = false
		self.u = 0

	end

	function ENT:StartCountdown()

		self.CurTick = CurTime()
		self.Counter = self.ExplodeTime * 2
		self.RealCounter = self.ExplodeTime
		self.CountingDown = true

		self:SetNW2Bool("show",true)

	end

	function ENT:StopCountdown()

		self.CountingDown = nil
		self:SetNW2String("counter","0")
		self:SetNW2Bool("show",false)

	end

	local beep = Sound("weapons/c4/c4_beep1.wav")
	function ENT:Beep()
		self:EmitSound(beep)
	end

	local plant = Sound("weapons/c4/c4_plant.wav")
	function ENT:Plant(ent)
		self:SetParent(ent)
		self:SetMoveType(MOVETYPE_NONE)
		self:EmitSound(plant)
		self:StartCountdown()
	end

	local defuse = Sound("weapons/c4/c4_disarm.wav")
	function ENT:Defuse()
		self:EmitSound(defuse)
		self:StopCountdown()
		self.Defused = true

	end

	function ENT:Explode()

		self:SetNW2Bool("show",false)

		local exp = ents.Create("env_explosion")

		exp:SetKeyValue("iMagnitude",self.ExplodeRadius)
		exp:SetKeyValue("spawnflags",64)
		exp:SetPos(self:GetPos())
		exp:Spawn()
		exp:Activate()
		exp:Fire("explode")
		exp.Owner = self.Owner

		self:ExplodeEffects()
		SafeRemoveEntity(self)
		SafeRemoveEntityDelayed(env, 0.1)

	end

	function ENT:ExplodeEffects()

		local ef = EffectData()
		ef:SetOrigin(self:GetPos())

		util.Effect("Explosion", ef)
		util.Effect("Explosion", ef)
		self:EmitSound("weapons/c4/c4_explode1.wav")
		self:EmitSound("weapons/hegrenade/explode5.wav")

	end

	function ENT:StartUse()
	end

	function ENT:EndUse()
		self:SetNW2Int("defuseprogress",0)
	end

	function ENT:AlphaDec()
		local al = self:GetColor().a
		al = al - 5
		if al <= 0 then
			SafeRemoveEntity(self)
		return end
		self:SetColor(ColorAlpha(self:GetColor(), al))
	end

	function ENT:Think()

		if self.ddd and self.ddd <= CurTime() then
			self:AlphaDec()
			self:NextThink(CurTime() + 0.01)
		return true end

		if self.ddd then return end

		if self.Defused then
			self:SetNW2String("counter","0")
			self.ddd = CurTime() + 1
		return end
		self:SetNW2String("counter", tostring(math.ceil(self.RealCounter or 0)))

		if self.u > 0 then
			self:SetNW2Bool("using", true)
			self.u = self.u - 1
			if not self.used then
				self:StartUse()
				self.used = true
			end
		else
			self:SetNW2Bool("using", false)
			self.used = nil
			self:EndUse()
		end

		if self:GetNW2Int("defuseprogress",0) >= 400 then
			local ply = self.defusor
			if self.RealCounter <= 1 and IsValid(ply) and ply.TriggerAchievement then
				ply:TriggerAchievement("1secbomb")
			end
			self:Defuse()
		return end

		if self.AboutToExplode then
			self:Explode()
		return end

		if self.CountingDown then

			if self.CurTick <= CurTime() - 1 then
				
			end

			if self.CurTick <= CurTime() - ((self.Counter > 10 and 1) or (self.Counter > 2 and 0.5) or 0.125) then

				if self.Counter > 10 then
					self.RealCounter = self.RealCounter - 1
				elseif self.Counter > 2 then
					self.RealCounter = self.RealCounter - 0.5
				else
					self.RealCounter = self.RealCounter - 0.125
				end
				
				self.Counter = self.Counter - ((self.Counter > 10 and 2) or (self.Counter > 2 and 1) or 0.25)
				self:Beep()

				if self.Counter <= 0 then
					self.AboutToExplode = true
				end

				self.CurTick = CurTime()

			end

		end

	end

	function ENT:Use(activator, caller, ut, value)
		if activator:IsPlayer() then
			self.u = 2
			self:SetNW2Int("defuseprogress",self:GetNW2Int("defuseprogress",0) + 1)
			self.defusor = activator
		end
	end
	
else

	function ENT:GetCounter()

		return tonumber(self:GetNW2String("counter","0"))

	end

	hook.Add("HUDPaint","BaseWars.DrawBomb_EndGame",function()

		if not IsValid(LocalPlayer()) then return end

		for _, ent in pairs(ents.GetAll()) do
			if IsValid(ent) and (ent:GetClass() == "bw_c4" or ent.Base == "bw_c4") and ent.ShowTimer and ent:GetNW2Bool("show") then

				local pos = ent:GetPos()

				if pos:Distance(LocalPlayer():GetPos()) > 1200 then continue end

				local t = pos:ToScreen()

				local x, y = t.x, t.y

				local counter = ent:GetCounter()

				if not counter then print"wat" return end
					
				if counter == 0 then
					draw.DrawText("DEFUSED","ChatFont", x, y, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				continue end

				local sec, min = counter % 60, math.floor(counter / 60)
				sec = sec < 10 and "0" .. sec or tostring(sec)
				min = min < 10 and "0" .. min or tostring(min)

				draw.DrawText(min .. ":" .. sec,"ChatFont", x, y, Color(255, 255, 255), TEXT_ALIGN_CENTER)

				local defprogress = ent:GetNW2Int("defuseprogress")
				if defprogress > 0 then
					local prog = math.Clamp(defprogress / 400, 0.01, 1)
					local w, h = ScrW() / 12, 24
					local wprog = math.max(w * prog, 4)
					draw.RoundedBox(2, x - w / 2, y + 32, w, h, Color(100, 100, 100))
					draw.RoundedBox(2, x - w / 2 + 2, y + 34, wprog - 4, h - 4, Color(170, 170, 170))
					draw.DrawText("DEFUSING...","ChatFont", x, y + 34, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				end

			end
		end

	end)

end
