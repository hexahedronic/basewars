MODULE.Name 	= "AntiRDM"
MODULE.Author 	= "Q2F2 & Ghosty"

local tag = "BaseWars.AntiRDM"
local PLAYER = debug.getregistry().Player

if CLIENT then

surface.CreateFont(tag, {
	font = "Roboto Condensed",
	size = 46,
	weight = 800,
})

function MODULE:GetRespawnTime(ply)

	return ply:GetNWInt("RespawnTime", 0)

end

PLAYER.GetRespawnTime = Curry(MODULE.GetRespawnTime)

function MODULE:Paint()

	local ply = LocalPlayer()

	if (ply.IsAFK and ply:IsAFK()) or not ply:GetRespawnTime() or ply:Alive() then return end

	local len = ply:GetRespawnTime()

	if len < 1 then return end

	local m = math.floor(len / 60) % 60
	local s = math.floor(len) % 60

	local RespawnTime = string.format("%.2d:%.2d", m, s)

	surface.SetFont(tag)
	local w, h = surface.GetTextSize(RespawnTime)

	surface.SetTextColor(color_black)

	surface.SetTextPos(ScrW() / 2 - w / 2 + 1, ScrH() / 3 + 1)
	surface.DrawText(RespawnTime)

	surface.SetTextColor(color_white)

	surface.SetTextPos(ScrW() / 2 - w / 2, ScrH() / 3)
	surface.DrawText(RespawnTime)

	local Txt = BaseWars.LANG.RespawnIn
	local w2, h2 = surface.GetTextSize(Txt)

	surface.SetTextColor(color_black)

	surface.SetTextPos(ScrW() / 2 - w2 / 2 + 1, ScrH() / 3 - h2)
	surface.DrawText(Txt)

	surface.SetTextColor(color_white)

	surface.SetTextPos(ScrW() / 2 - w2 / 2, ScrH() / 3 - h2 - 1)
	surface.DrawText(Txt)

end

hook.Add("HUDPaint", tag .. ".Paint", Curry(MODULE.Paint))

local Red = Color(255, 0, 0, 255)
local Green = Color(0, 255, 0, 255)
function MODULE:PreDrawHalos()

	local Plys, Plys2 = {}, {}

	for _, p in next, player.GetAll() do

		if not p:Alive() then continue end

		local Karma = p:GetKarma()

		if Karma > BaseWars.Config.AntiRDM.KarmaGlowLevel then

			Plys[#Plys + 1] = p

		elseif Karma < -BaseWars.Config.AntiRDM.KarmaGlowLevel then

			Plys2[#Plys2 + 1] = p

		end

	end

	halo.Add(Plys, Green, 1, 1)
	halo.Add(Plys2, Red, 1, 1)

end

hook.Add("PreDrawHalos", tag .. ".PreDrawHalos", Curry(MODULE.PreDrawHalos))

else

function MODULE:IsRDM(ply, ply2)

	if ply == ply2 then return false end

	if ply:InRaid() and ply2:InRaid() then return false end

	if ply.RecentlyHurtBy[ply2] and ply.RecentlyHurtBy[ply2] < CurTime() + BaseWars.Config.AntiRDM.HurtTime then return false end

	return true

end

function MODULE:CalculateSpawnTime(ply)

	local delay = 0
	delay = delay + (ply.RDMS * BaseWars.Config.AntiRDM.RDMSecondsAdd)

	local karma = ply:GetKarma()
	if karma < 0 then

		karma = math.abs(karma)
		delay = delay + (karma / BaseWars.Config.AntiRDM.KarmaSecondPer)

	end

	return CurTime() + delay

end
PLAYER.CalculateSpawnTime = Curry(MODULE.CalculateSpawnTime)

function MODULE:OnEntityTakeDamage(ply, dmginfo)

	local Attacker = dmginfo:GetAttacker()
	if not BaseWars.Ents:ValidPlayer(Attacker) then return end

	ply.RecentlyHurtBy = ply.RecentlyHurtBy or {}
	ply.RecentlyHurtBy[Attacker] = CurTime()

end
hook.Add("OnTakeDamage", tag .. ".TakeDamage", Curry(MODULE.OnEntityTakeDamage))

function MODULE:PlayerDeath(ply, inflictor, attacker)

	if not BaseWars.Ents:ValidPlayer(attacker) then return end
	if self:IsRDM(ply, attacker) then

		attacker.RDMS = (attacker.RDMS or 0) + 1
		attacker:AddKarma(BaseWars.Config.AntiRDM.KarmaLoss)

	end

	ply.RecentlyHurtBy = {}
	ply.NextSpawn = ply:CalculateSpawnTime()
	ply.RDMS = 0

end
hook.Add("PlayerDeath", tag .. ".PlayerDeath", Curry(MODULE.PlayerDeath))

function MODULE:PlayerDeathThink(ply)

	if not ply.NextSpawn or ply.NextSpawn == math.huge or ply.NextSpawn ~= ply.NextSpawn then

		ply.NextSpawn = CurTime()

	end

	if CurTime() >= ply.NextSpawn then

		ply:SetNWInt("RespawnTime", 0)

	return end

	local Time = ply.NextSpawn - CurTime()
	if Time > 300 then Time = 300 end

	ply:SetNWInt("RespawnTime", Time)

	return false
end

hook.Add("PlayerDeathThink", tag .. ".PlayerDeathThink", Curry(MODULE.PlayerDeathThink))

function MODULE:PlayerInitialSpawn(ply)

	ply.NextSpawn = math.huge
	ply.RecentlyHurtBy = {}
	ply.RDMS = 0

end

hook.Add("PlayerInitialSpawn", tag .. ".PlayerInitialSpawn", Curry(MODULE.PlayerInitialSpawn))

end
