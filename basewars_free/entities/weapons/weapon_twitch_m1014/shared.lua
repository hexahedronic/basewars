SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "shotgun"
end

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch M1014"

SWEP.Slot					= 2
SWEP.IconLetter				= "k"

SWEP.ViewModel				= "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel				= "models/weapons/w_shot_xm1014.mdl"
SWEP.ViewModelAimPos		= Vector (4.3262, 0, 1.5635)
SWEP.ViewModelAimPosMax		= SWEP.ViewModelAimPos
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_XM1014.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/xm1014/xm1014-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= 0.04
SWEP.Primary.Delay			= 0.3

SWEP.Primary.ClipSize		= 9
SWEP.Primary.DefaultClip	= 64
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Recoil					= 4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadDelay			= 0.4
SWEP.CustomReload			= true

function SWEP:Reload()
	if SERVER and game.SinglePlayer() then
		self.Owner:SendLua ("LocalPlayer():GetActiveWeapon():Reload()")
	end
	
 	if self.Weapon:GetNWBool ("reloading", false) then return end
	
 	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
 		self.Weapon:SetNWBool ("reloading", true)
 		self.nextReload = CurTime() + self.ReloadDelay
		self.Weapon:SetNextPrimaryFire (CurTime() + 9999)
 		self.Weapon:SendWeaponAnim (ACT_VM_RELOAD)
 	end
end

function SWEP:CustomThink()
	if self.Weapon:GetNWBool ("reloading", false) then
		self.Reloading = true
		if (self.nextReload or 0) < CurTime() then
			if self.Primary.ClipSize <= self.Weapon:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self.Weapon:SetNWBool ("reloading", false)
				return
			end
			
			self.nextReload = CurTime() + self.ReloadDelay
			self.Weapon:SendWeaponAnim (ACT_VM_RELOAD)
			
			self.Owner:RemoveAmmo (1, self.Primary.Ammo, false)
			self.Weapon:SetClip1 (self.Weapon:Clip1()+1)
			
			if self.Primary.ClipSize <= self.Weapon:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then
				self.Weapon:SendWeaponAnim (ACT_SHOTGUN_RELOAD_FINISH)
				self.nextReload = CurTime() + self.ReloadDelay
				self.Weapon:SetNextPrimaryFire (CurTime() + 0.3)
				self.Weapon:SetNWBool ("reloading", false)
			end
		end
	elseif (self.nextReload or 0) + 0.1 < CurTime() then
		self.Reloading = false
	end
end

function SWEP:CustomPrimaryAttack()
	if SERVER and game.SinglePlayer() then 
		self.Owner:SendLua("LocalPlayer():GetActiveWeapon().FireTime = CurTime()")
		return
	end
	self.FireTime = CurTime()
end

if CLIENT then killicon.AddFont ("weapon_twitch_m1014", "CSKillIcons", "B", Color (150, 150, 255, 255)) end
