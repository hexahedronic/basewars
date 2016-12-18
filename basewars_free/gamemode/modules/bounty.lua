MODULE.Name 	= "Bounty"
MODULE.Author 	= "Trixter"
MODULE.BountyTable = {}

local tag = "BaseWars.Bounty"
local PLAYER = debug.getregistry().Player

function MODULE:__INIT()

	if __BASEWARS_BOUNTY_BACKUP then

		BaseWars.UTIL.Log("Detected bounty backup. ATTEMPTING TO RESTORE.")
		self.BountyTable = table.Copy(__BASEWARS_BOUNTY_BACKUP)

		__BASEWARS_BOUNTY_BACKUP = nil

	end

end

if SERVER then

	function MODULE:GetBountyTbl()
		return BaseWars.Bounty.BountyTable
	end

	function MODULE:PlaceBounty(ply, who, amt)

		if not IsValid(ply) or not IsValid(who) then return false, BaseWars.LANG.InvalidPlayer end
		if who:GetMoney() < amt then return false, BaseWars.LANG.BountyNotEnoughMoney end

		local tbl = self:GetBountyTbl()

		who:TakeMoney( amt )
		tbl[ply:SteamID()] = amt

		PrintMessage(3, "Bounty of " .. BaseWars.LANG.CURRENCY .. BaseWars.NumberFormat(amt) .. " has been placed on " .. ply:Name())
		BaseWars.UTIL.Log("Players " .. ply:Name() .. " bounty was set to " .. BaseWars.LANG.CURRENCY .. BaseWars.NumberFormat(amt) .. ".")

	end
	PLAYER.PlaceBounty = Curry(MODULE.PlaceBounty)

	function MODULE:RemoveBounty(ply)

		local tbl = self:GetBountyTbl()
		tbl[ply:SteamID()] = nil

		ply:SetNWInt(tag, 0)

		PrintMessage(3, "Bounty on " .. ply:Name() .. " has been removed.")
		BaseWars.UTIL.Log("Players " .. ply:Name() .. " bounty was removed." )

	end
	PLAYER.RemoveBounty = Curry(MODULE.RemoveBounty)

	function MODULE:PlayerDeath( victim, inflictor, attacker )

		if not IsValid(victim) or not IsValid(attacker) or not victim:IsPlayer() or not attacker:IsPlayer() then return end
		if victim == attacker then return end

		local tbl = self:GetBountyTbl()
		local amt = tbl[victim:SteamID()]

		if not amt then return end

		attacker:GiveMoney( amt )
		tbl[victim:SteamID()] = nil

		PrintMessage(3, "Bounty on " .. victim:Name() .. " has been claimed by " .. attacker:Name() .. ".")

	end
	hook.Add("PlayerDeath", tag, Curry(MODULE.PlayerDeath))

end

function MODULE:GetBounty(ply)

	if SERVER then
		return self:GetBountyTbl()[ply:SteamID()]
	else
		return self:GetNW2Int(tag, 0)
	end

end
PLAYER.GetBounty = Curry(MODULE.GetBounty)
