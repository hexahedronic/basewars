-- Author: BROLY, http://steamcommunity.com/id/tehbroly

local CATEGORY_NAME = "BaseWars"

function ulx.addmoney(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:GiveMoney(amt)
		table.insert(affected_plys, v)

	end

	ulx.fancyLogAdmin(calling_ply, "#A gave " .. BaseWars.LANG.Currency .. "#s to #T", affected_plys, amt)

end

local addmoney = ulx.command(CATEGORY_NAME, "ulx addmoney", ulx.addmoney, "!addmoney")
	addmoney:addParam{type = ULib.cmds.PlayersArg}
	addmoney:addParam{type = ULib.cmds.NumArg, min = 0, max = 10^12, hint = "Money", ULib.cmds.round}
	addmoney:defaultAccess(ULib.ACCESS_ADMIN)
	addmoney:help("Give a player money.")


function ulx.takemoney(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:TakeMoney(amt)
		table.insert(affected_plys, v)

	end
	ulx.fancyLogAdmin(calling_ply, "#A took " .. BaseWars.LANG.Currency .. "#s from #T", affected_plys, amt)

end

local takemoney = ulx.command(CATEGORY_NAME, "ulx takemoney", ulx.takemoney, "!takemoney")
	takemoney:addParam{type = ULib.cmds.PlayersArg}
	takemoney:addParam{type = ULib.cmds.NumArg, min = 0, max = 10^12, hint = "Money", ULib.cmds.round}
	takemoney:defaultAccess(ULib.ACCESS_ADMIN)
	takemoney:help("Take a players money.")


function ulx.setmoney(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:SetMoney(amt)
		table.insert(affected_plys, v)

	end
	ulx.fancyLogAdmin(calling_ply, "#A set #T's money to " .. BaseWars.LANG.Currency .. "#s", affected_plys, amt)

end

local setmoney = ulx.command(CATEGORY_NAME, "ulx setmoney", ulx.setmoney, "!setmoney")
	setmoney:addParam{type = ULib.cmds.PlayersArg}
	setmoney:addParam{type = ULib.cmds.NumArg, min = 0, max = 10^12, hint = "Money", ULib.cmds.round}
	setmoney:defaultAccess(ULib.ACCESS_ADMIN)
	setmoney:help("Set a players money.")


function ulx.addlevel(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:AddLevel(amt)
		table.insert(affected_plys, v)

	end

	ulx.fancyLogAdmin(calling_ply, "#A added #s to #T's level", affected_plys, amt)

end

local addlevel = ulx.command(CATEGORY_NAME, "ulx addlevel", ulx.addlevel, "!addlevel")
	addlevel:addParam{type = ULib.cmds.PlayersArg}
	addlevel:addParam{type = ULib.cmds.NumArg, min = 0, max = 5000, hint = "Level", ULib.cmds.round}
	addlevel:defaultAccess(ULib.ACCESS_ADMIN)
	addlevel:help("Add levels to a player.")


function ulx.setlevel(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do
		local v = target_plys[i]

		v:SetLevel(amt)
		table.insert(affected_plys, v)

	end

	ulx.fancyLogAdmin(calling_ply, "#A set #T's level to #s", affected_plys, amt)

end

local setlevel = ulx.command(CATEGORY_NAME, "ulx setlevel", ulx.setlevel, "!setlevel")
	setlevel:addParam{type = ULib.cmds.PlayersArg}
	setlevel:addParam{type = ULib.cmds.NumArg, min = 0, max = 5000, hint = "Level", ULib.cmds.round}
	setlevel:defaultAccess(ULib.ACCESS_ADMIN)
	setlevel:help("Set a players level.")


function ulx.addxp(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:AddXP(amt)
		table.insert(affected_plys, v)

	end

	ulx.fancyLogAdmin(calling_ply, "#A added #s to #T's XP", affected_plys, amt)

end

local addxp = ulx.command(CATEGORY_NAME, "ulx addxp", ulx.addxp, "!addxp")
	addxp:addParam{type = ULib.cmds.PlayersArg}
	addxp:addParam{type = ULib.cmds.NumArg, min = 0, max = 1250250, hint = "XP", ULib.cmds.round}
	addxp:defaultAccess(ULib.ACCESS_ADMIN)
	addxp:help("Add XP to a player.")


function ulx.setxp(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:SetXP(amt)
		table.insert(affected_plys, v)

	end

	ulx.fancyLogAdmin(calling_ply, "#A set #T's XP to #s", affected_plys, amt)

end

local setxp = ulx.command(CATEGORY_NAME, "ulx setxp", ulx.setxp, "!setxp")
	setxp:addParam{type = ULib.cmds.PlayersArg}
	setxp:addParam{type = ULib.cmds.NumArg, min = 0, max = 1250250, hint = "XP", ULib.cmds.round}
	setxp:defaultAccess(ULib.ACCESS_ADMIN)
	setxp:help("Set a players XP.")


function ulx.addkarma(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:AddKarma(amt)
		table.insert(affected_plys, v)

	end

	ulx.fancyLogAdmin(calling_ply, "#A added #s to #T's karma", affected_plys, amt)

end

local addkarma = ulx.command(CATEGORY_NAME, "ulx addkarma", ulx.addkarma, "!addkarma")
	addkarma:addParam{type = ULib.cmds.PlayersArg}
	addkarma:addParam{type = ULib.cmds.NumArg, min = -100, max = 100, hint = "Karma", ULib.cmds.round}
	addkarma:defaultAccess(ULib.ACCESS_ADMIN)
	addkarma:help("Add Karma to a player.")



function ulx.setkarma(calling_ply, target_plys, amt)

	local affected_plys = {}
	for i = 1, #target_plys do

		local v = target_plys[i]

		v:SetKarma(amt)
		table.insert(affected_plys, v)

	end

	ulx.fancyLogAdmin(calling_ply, "#A set #T's karma to #s", affected_plys, amt)

end


local setkarma = ulx.command(CATEGORY_NAME, "ulx setkarma", ulx.setkarma, "!setkarma")
	setkarma:addParam{type = ULib.cmds.PlayersArg}
	setkarma:addParam{type = ULib.cmds.NumArg, min = -100, max = 100, hint = "Karma", ULib.cmds.round}
	setkarma:defaultAccess(ULib.ACCESS_ADMIN)
	setkarma:help("Set a players Karma.")
