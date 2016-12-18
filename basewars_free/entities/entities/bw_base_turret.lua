AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
 
ENT.PrintName = "Turret"
ENT.Model = "models/Combine_turrets/Floor_turret.mdl"
 
ENT.PowerRequired = 10
ENT.PowerMin = 1000
ENT.PowerCapacity = 2500
 
ENT.Drain = 35
 
ENT.Damage = 2
ENT.Radius = 750
ENT.ShootingDelay = 0.08
ENT.Ammo = -1
ENT.Angle = math.rad(45)
ENT.LaserColor = Color(0, 255, 0)
 
ENT.EyePosOffset 	= Vector(0, 0, 0)
ENT.Sounds 			= Sound("npc/turret_floor/shoot1.wav")
ENT.NoAmmoSound		= Sound("weapons/pistol/pistol_empty.wav")

ENT.PresetMaxHealth = 500

ENT.AllwaysRaidable = true
 
if SERVER then

ENT.Spread = 15
ENT.NextShot = 0

function ENT:Init()

	self:SetModel(self.Model)
	
end

function ENT:SpawnBullet(target)

	if not self:IsPowered(self.PowerMin) then return end
	
	local Pos = target:LocalToWorld(target:OBBCenter()) + Vector(0, 0, 10)
	
	local tr = {}
		tr.start = self.EyePosOffset
		tr.endpos = Pos
		tr.filter = function(ent)
			
			if ent:IsPlayer() or ent:GetClass():find("prop_") then return true end
			
		end
	tr = util.TraceLine(tr)
 
	if tr.Entity == target then
	
		local Bullet = self:GetBulletInfo(target, Pos)
	   
		self:FireBullets(Bullet)
		
		self:DrainPower(self.Drain)
		self:EmitSound(self.Sounds)
		
		self.Ammo = self.Ammo - 1
		
	end
	
end

function ENT:GetBulletInfo(target, pos)

	local bullet = {}
		bullet.Num = 1
		bullet.Damage = self.Damage
		bullet.Force = 1
		bullet.TracerName = "AR2Tracer"
		bullet.Spread = Vector(self.Spread, self.Spread, 0)
		bullet.Src = self.EyePosOffset
		bullet.Dir = pos - self.EyePosOffset
		
	return bullet
		
end

function ENT:ThinkFunc()

	if self.NextShot > CurTime() then return end
	
	local Forward = self:GetForward()
	local SelfPos = self:GetPos()
	
	self.EyePosOffset = SelfPos + (self:GetUp() * 58 + Forward * 7 + self:GetRight() * 2)
	self.NextShot = CurTime() + self.ShootingDelay
	
	local plys = {}
	
	local find = ents.FindInCone(self.EyePosOffset, Forward, self.Radius, self.Angle)
	
	for k, v in next, find do
	
		if not BaseWars.Ents:ValidPlayer(v) then continue end
		
		local Owner = BaseWars.Ents:ValidOwner(self)
		if Owner and not Owner:IsEnemy(v) then continue end
		
		local Data = {
			ply = v,
			dist = SelfPos:Distance(v:GetPos()),
		}
		plys[#plys+1] = Data
		
	end
   
	if #plys <= 0 then
	
		return
	
	elseif self.Ammo == 0 then
	
		self:EmitSound(self.NoAmmoSound)
	
	return end
	
	table.SortByMember(plys, "dist", true)
	
	self:SpawnBullet(plys[1].ply)
	
end
 
else
 
function ENT:Draw()

	self:DrawModel()
	
	if not self:IsPowered(self.PowerMin) then return end
	
	local Forward = self:GetForward()
	local SelfPos = self:GetPos()
	
	self.EyePosOffset = SelfPos + (self:GetUp() * 58 + Forward * 7 + self:GetRight() * 2)
	
	local find = ents.FindInCone(self.EyePosOffset, Forward, self.Radius, self.Angle)
	
	for k, v in next, find do
	
		if not BaseWars.Ents:ValidPlayer(v) then continue end
		
		local Owner = BaseWars.Ents:ValidOwner(self)
		if Owner and not Owner:IsEnemy(v) then continue end
		
		local Pos = v:LocalToWorld(v:OBBCenter()) + Vector(0, 0, 10)
	
		local tr = {}
			tr.start = self.EyePosOffset
			tr.endpos = Pos
			tr.filter = function(ent)
				
				if ent:IsPlayer() or ent:GetClass():find("prop_") then return true end
				
			end
		tr = util.TraceLine(tr)
		
		if tr.Entity ~= v then continue end
		
		render.DrawLine(self.EyePosOffset, Pos, self.LaserColor, true)
		
	end
	
end
 
end
