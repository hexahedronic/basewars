MODULE.Name 	= "Drugs"
MODULE.Author 	= "Q2F2 & Ghosty"

local tag = "BaseWars.Drugs"
local PLAYER = debug.getregistry().Player

local DRUG_REMOVE = 0
local DRUG_FAILED = 1

MODULE.EffectTable = {
	["Stun"] = {
		Apply  = function(ply, dur)

			ply.StunDuration = dur

			if ply.StunDuration > 70 then ply.StunDuration = 70 end

			ply:ConCommand("pp_motionblur 1")
			ply:ConCommand("pp_motionblur_addalpha 0.1")
			ply:ConCommand("pp_motionblur_delay 0.035")

			local blindamount = ply.StunDuration * 0.025

			if blindamount > 1 then blindamount = 1 end

			ply:ConCommand("pp_motionblur_drawalpha " .. blindamount)

		end,
		Check  = function(ply)

			ply.StunDuration = ply.StunDuration - 1

			if ply:HasDrug("Antidote") then

				ply.StunDuration = ply.StunDuration - 3

			end

			local blindamount = ply.StunDuration * 0.025

			if blindamount > 1 then blindamount = 1 end

			ply:ConCommand("pp_motionblur_drawalpha " .. blindamount)

			if ply.StunDuration > 25 then

				local Mult = ply.StunDuration - 25
				local Ang = Angle(Mult * math.random() * 0.2, Mult * math.random() * 0.2, Mult * math.random() * 0.2)

				ply:ViewPunch(Ang)

			end

			if ply.StunDuration < 1 then

				return DRUG_REMOVE

			end

		end,
		Remove = function(ply)

			ply.StunDuration = nil

			ply:ConCommand("pp_motionblur 0")

		end,
	},

	["Poison"] = {
		Apply  = function(ply, dur, attk, infl)

			ply.PoisonAttacker 	= attk
			ply.PoisonInflictor = infl
			ply.PoisonDuration 	= dur

			if ply.PoisonDuration > 70 then ply.PoisonDuration = 70 end

			ply:TakeDamage(math.ceil(ply.PoisonDuration / 8), attk, infl)

		end,
		Check  = function(ply)

			ply.PoisonDuration = ply.PoisonDuration - 1

			if ply:HasDrug("Antidote") then

				ply.PoisonDuration = ply.PoisonDuration - 3

			end

			ply:TakeDamage(math.ceil(ply.PoisonDuration / 8), ply.PoisonAttacker, ply.PoisonInflictor)

			if ply.PoisonDuration < 1 then

				return DRUG_REMOVE

			end

		end,
		Remove = function(ply)

			ply.PoisonDuration = nil

		end,
	},

	["Steroid"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.SteroidEffect, BASEWARS_NOTIFICATION_DRUG)

			ply:SetWalkSpeed(BaseWars.Config.Drugs.Steroid.Walk)
			ply:SetRunSpeed(BaseWars.Config.Drugs.Steroid.Run)

		end,
		Check  = function(ply)

			-- None.

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.SteroidRemove, BASEWARS_NOTIFICATION_DRUG)

			ply:SetWalkSpeed(BaseWars.Config.DefaultWalk)
			ply:SetRunSpeed(BaseWars.Config.DefaultRun)

		end,
	},

	["Regen"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.RegenEffect, BASEWARS_NOTIFICATION_DRUG)

		end,
		Check  = function(ply)

			if ply:Health() < ply:GetMaxHealth() then

				ply:SetHealth(ply:Health() + 2)
				if ply:Health() > ply:GetMaxHealth() then ply:SetHealth(ply:GetMaxHealth()) end

			elseif ply:Armor() < 100 then

				ply:SetArmor(ply:Armor() + 1)
				if ply:Armor() > 100 then ply:SetArmor(100) end

			end

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.RegenRemove, BASEWARS_NOTIFICATION_DRUG)

		end,
	},

	["Shield"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.ShieldEffect, BASEWARS_NOTIFICATION_DRUG)

		end,
		Check  = function(ply)

			-- None.
			-- Handled in EntityTakeDamage.

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.ShieldRemove, BASEWARS_NOTIFICATION_DRUG)

		end,
	},

	["Rage"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.RageEffect, BASEWARS_NOTIFICATION_DRUG)

		end,
		Check  = function(ply)

			-- None.
			-- Handled in EntityTakeDamage.

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.RageRemove, BASEWARS_NOTIFICATION_DRUG)

		end,
	},

	["PainKiller"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.PainKillerEffect, BASEWARS_NOTIFICATION_DRUG)

		end,
		Check  = function(ply)

			-- None.
			-- Handled in EntityTakeDamage.

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.PainKillerRemove, BASEWARS_NOTIFICATION_DRUG)

		end,
	},

	["Antidote"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.AntidoteEffect, BASEWARS_NOTIFICATION_DRUG)

		end,
		Check  = function(ply)

			-- None.
			-- Passive drug effector.

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.AntidoteRemove, BASEWARS_NOTIFICATION_DRUG)

		end,
	},

	["Adrenaline"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.AdrenalineEffect, BASEWARS_NOTIFICATION_DRUG)

			ply:SetMaxHealth(ply:GetMaxHealth() * BaseWars.Config.Drugs.Adrenaline.Mult)
			ply:SetHealth(ply:Health() * BaseWars.Config.Drugs.Adrenaline.Mult)

		end,
		Check  = function(ply)

			-- None.

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.AdrenalineRemove, BASEWARS_NOTIFICATION_DRUG)

			ply:SetMaxHealth(ply:GetMaxHealth() / BaseWars.Config.Drugs.Adrenaline.Mult)
			ply:SetHealth(math.max(ply:Health() / BaseWars.Config.Drugs.Adrenaline.Mult, 1))

		end,
	},

	["DoubleJump"] = {
		Apply  = function(ply, dur)

			ply:Notify(BaseWars.LANG.DoubleJumpEffect, BASEWARS_NOTIFICATION_DRUG)

		end,
		Check  = function(ply)

			-- None.
			-- Handled in KeyPress.

		end,
		Remove = function(ply)

			ply:Notify(BaseWars.LANG.DoubleJumpRemove, BASEWARS_NOTIFICATION_DRUG)

		end,
	},
}

function MODULE:HasDrug(ply, effect)

	return ply:GetNWBool(tag .. "." .. effect)

end
PLAYER.HasDrug = Curry(MODULE.HasDrug)

function MODULE:RemoveDrug(ply, effect)

	if CLIENT then return end

	if not BaseWars.Ents:ValidPlayer(ply) then return false end

	local E = self.EffectTable[effect]
	local TID = ply:SteamID64() .. "." .. tag .. "." .. effect

	if not E then return false end
	if not ply:HasDrug(effect) then return false end

	BaseWars.UTIL.TimerAdvDestroy(TID)

	E.Remove(ply)
	ply:SetNWBool(tag .. "." .. effect, false)

	if ply.__Effects then

		ply.__Effects[effect] = nil

	end

	ply:EmitSound("player/spy_uncloak.wav")

	return true

end
PLAYER.RemoveDrug = Curry(MODULE.RemoveDrug)

function MODULE:ClearDrugs(ply)

	if CLIENT then return end

	local Effects = ply.__Effects

	if not Effects then return false end

	for k, v in next, Effects do

		local Res = ply:RemoveDrug(v)

		if not Res then

			BaseWars.UTIL.Log("DRUG ERROR ", ply, " -> Failed to remove effect '", v, "'.")

		continue end

	end

	return true

end
PLAYER.ClearDrugs = Curry(MODULE.ClearDrugs)

function MODULE:ApplyDrug(ply, effect, dur, ...)

	if CLIENT then return end

	if not BaseWars.Ents:ValidPlayer(ply) then return false end

	local dur = dur or (BaseWars.Config.Drugs[effect] and BaseWars.Config.Drugs[effect].Duration or 60)
	local E = self.EffectTable[effect]
	local TID = ply:SteamID64() .. "." .. tag .. "." .. effect

	if not E then return false end

	if ply:HasDrug(effect) then

		ply:RemoveDrug(effect)

	end

	local Res = E.Apply(ply, dur, ...)

	if Res == DRUG_FAILED then return false end

	ply.__Effects = ply.__Effects or {}
	ply.__Effects[effect] = effect

	ply:SetNWBool(tag .. "." .. effect, true)

	local Done = function()

		if not BaseWars.Ents:ValidPlayer(ply) then return end

		E.Remove(ply)
		ply:SetNWBool(tag .. "." .. effect, false)

		ply.__Effects[effect] = nil

	end

	local Tick = function()

		if not BaseWars.Ents:ValidPlayer(ply) then

			BaseWars.UTIL.TimerAdvDestroy(TID)

		return end

		local Res = E.Check(ply)

		if Res == DRUG_REMOVE then

			ply:RemoveDrug(effect)

		return end

		if not ply:Alive() then

			ply:RemoveDrug(effect)

		return end

	end

	BaseWars.UTIL.TimerAdv(TID, 0.3, dur / 0.3, Tick, Done)

	ply:EmitSound("player/spy_cloak.wav")

	return true

end
PLAYER.ApplyDrug = Curry(MODULE.ApplyDrug)
