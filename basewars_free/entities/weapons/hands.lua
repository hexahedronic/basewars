SWEP.Base = "weapon_base"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.PrintName = "Hands"
SWEP.DrawCrosshair = false
SWEP.HoldType = "normal"

SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= true
SWEP.Weight 		= 1

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:CanPrimaryAttack() return false end
function SWEP:CanSecondaryAttack() return false end
function SWEP:Reload() return false end

function SWEP:PreDrawViewModel() return true end
function SWEP:DrawWorldModel() return false end

function SWEP:CustomAmmoDisplay() return {} end
function SWEP:DrawWeaponSelection(x, y, w, h, t, a)

	draw.SimpleText("C", "creditslogo", x + w / 2, 0, Color(255, 220, 0, a), TEXT_ALIGN_CENTER)
	
end

local function Lockable(ply, ent)

    local Eyes = ply:EyePos()
	local Class = ent:GetClass()
	
    return BaseWars.Ents:Valid(ent) and Eyes:Distance(ent:GetPos()) < 65 and Class:find("door")

end

function SWEP:PrimaryAttack()

	local ply = self:GetOwner()
    local trace = ply:GetEyeTrace()

	local Ent = trace.Entity
    if not Lockable(ply, Ent) then return end

    self:SetNextPrimaryFire(CurTime() + 1)

    if CLIENT then return end

    Ent:Fire("lock")
	ply:EmitSound("npc/metropolice/gear" .. math.random(1, 7) .. ".wav")
	
end

function SWEP:SecondaryAttack()

	local ply = self:GetOwner()
    local trace = ply:GetEyeTrace()

	local Ent = trace.Entity
    if not Lockable(ply, Ent) then return end

    self:SetNextPrimaryFire(CurTime() + 1)

    if CLIENT then return end

    Ent:Fire("unlock")
	ply:EmitSound("npc/metropolice/gear" .. math.random(1,7) .. ".wav")
	
end
