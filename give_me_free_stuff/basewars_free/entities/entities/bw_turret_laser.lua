AddCSLuaFile()

ENT.Base = "bw_base_turret"
ENT.Type = "anim"
 
ENT.PrintName = "Laser Turret"
ENT.Model = "models/Combine_turrets/Floor_turret.mdl"
 
ENT.PowerRequired = 10
ENT.PowerMin = 1000
ENT.PowerCapacity = 2500
 
ENT.Drain = 150
 
ENT.Damage = 80
ENT.Radius = 1250
ENT.ShootingDelay = 3.8
ENT.Ammo = -1

ENT.Sounds = Sound("npc/strider/fire.wav")

if SERVER then
 
ENT.Spread = 2

function ENT:GetBulletInfo(target, pos)

	local bullet = {}
		bullet.Num = 1
		bullet.Damage = self.Damage
		bullet.Force = 15
		bullet.TracerName = "ToolTracer"
		bullet.Spread = Vector(self.Spread, self.Spread, 0)
		bullet.Src = self.EyePosOffset
		bullet.Dir = pos - self.EyePosOffset
		
	return bullet
		
end

end
