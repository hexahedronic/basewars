BaseWars.Commands = {
	cmds = {},
}

if ulx or ulib then
	BaseWars.Commands.Pattern = "[/|%.]"
else
	BaseWars.Commands.Pattern = "[!|/|%.]"
end

function BaseWars.Commands.ParseArgs(str)

	local ret 		= {}
	local InString 	= false
	local strchar 	= ""
	local chr 		= ""
	local escaped 	= false

	for i=1, #str do

		local char = str[i]

		if escaped then

			chr = chr..char
			escaped = false

		continue end

		if char:find("[\"|']") and not InString and not escaped then

			InString 	= true
			strchar 	= char

		elseif char:find("[\\]") then

			escaped 	= true

			continue

		elseif InString and char == strchar then

			ret[#ret+1] = chr:Trim()
			chr 		= ""
			InString 	= false

		elseif char:find("[ ]") and not InString and chr ~= "" then

			ret[#ret+1] = chr
			chr 		= ""

		else
			chr = chr .. char

		end

	end

	if chr:Trim():len() ~= 0 then

		ret[#ret+1] = chr

	end

	return ret

end

function BaseWars.Commands.CallCommand(ply, cmd, line, args)

	BaseWars.UTIL.Log("COMMAND: ", ply, " -> ", cmd, "[", line, "]")

	local ok, msg = pcall(function()

		local allowed, reason = hook.Run("BaseWarsCommand", cmd, ply, line, unpack(args))

		cmd = BaseWars.Commands.cmds[cmd]

		if allowed ~= false then

			if easylua then easylua.Start(ply) end

				allowed, reason = cmd.CallBack(ply, line, unpack(args))

			if easylua then easylua.End() end

		end

		if ply:IsValid() then

			if allowed == false then

				ply:EmitSound("buttons/button8.wav")

				if reason then

					ply:SendLua(string.format([[local s = "%s" notification.AddLegacy(s, 1, 4)]], reason))

				end

			end

		end
	end)

	if not ok then

		ErrorNoHalt(msg)

		return msg

	end

end

function BaseWars.Commands.ConCommand(ply, cmd, args, line)

	local Cmd = args[1]
	if not Cmd then return end

	local TblCmd = BaseWars.Commands.cmds[Cmd]
	if not TblCmd then return end

	if not BaseWars.Ents:Valid(ply) or (TblCmd.IsAdmin and not ply:IsAdmin()) then return end

	if ply.IsBanned and ply:IsBanned() and not ply:IsAdmin() then return end

	table.remove(args, 1)

	BaseWars.Commands.CallCommand(ply, Cmd, table.concat(args, " "), args)

end

function BaseWars.Commands.SayCommand(ply, txt, team)

	if not txt:sub(1, 1):find(BaseWars.Commands.Pattern) then return end

	local cmd 	= txt:match(BaseWars.Commands.Pattern .. "(.-) ") or txt:match(BaseWars.Commands.Pattern .. "(.+)") or ""
	local line 	= txt:match(BaseWars.Commands.Pattern .. ".- (.+)")

	cmd = cmd:lower()

	if not cmd then return end

	local TblCmd = BaseWars.Commands.cmds[cmd]
	if not TblCmd then return end

	if not BaseWars.Ents:Valid(ply) or (TblCmd.IsAdmin and not ply:IsAdmin()) then return end

	BaseWars.Commands.CallCommand(ply, cmd, line, line and BaseWars.Commands.ParseArgs(line) or {})

	return ""

end

function BaseWars.Commands.AddCommand(cmd, callback, admin)

	if istable(cmd) then

		for k, v in next, cmd do

			BaseWars.Commands.AddCommand(v, callback, admin)

		end

		return

	end

	BaseWars.Commands.cmds[cmd] 	= {CallBack = callback, IsAdmin = admin, Cmd = cmd}

end

concommand.Add("basewars", BaseWars.Commands.ConCommand)
hook.Add("PlayerSay", "BaseWars.Commands", BaseWars.Commands.SayCommand)

local dist = 100^2
local function Upgradable(ply, ent)

	local Eyes = ply:EyePos()
	local Class = ent:GetClass()

	return BaseWars.Ents:Valid(ent) and Eyes:DistToSqr(ent:GetPos()) < dist and ent.Upgrade

end
BaseWars.Commands.AddCommand({"upg", "upgrade", "upgr"}, function(ply)

	local trace = ply:GetEyeTrace()

	local Ent = trace.Entity
	if not Upgradable(ply, Ent) then return false end

	Ent:Upgrade(ply)

end, false)

BaseWars.Commands.AddCommand({"tell", "msg"}, function(ply, line, who)

	if not who then return false, BaseWars.LANG.InvalidPlayer end

	local Targ = easylua.FindEntity(who)

	if not BaseWars.Ents:ValidPlayer(Targ) then return false, BaseWars.LANG.InvalidPlayer end

	local Msg = line:sub(#who + 1):Trim()

	Targ:ChatPrint(ply:Nick() .. " -> " .. Msg)

end, false)

BaseWars.Commands.AddCommand("psa", function(ply, line, text)

	if text then

		BroadcastLua([[BaseWars.PSAText = "]] .. line .. [["]])

	else

		BroadcastLua([[BaseWars.PSAText = nil]])

	end

end, true)

BaseWars.Commands.AddCommand({"sell", "destroy", "remove"}, function(ply)

	local trace = ply:GetEyeTrace()

	local Ent = trace.Entity
	if not Ent.CurrentValue then return false end

	local Owner = BaseWars.Ents:ValidOwner(Ent)
	if Owner ~= ply then return false end

	if ply:InRaid() then return false end

	BaseWars.UTIL.PayOut(Ent, ply)
	Ent:Remove()

end, false)

BaseWars.Commands.AddCommand({"dw", "dropweapon", "dropwep"}, function(ply)

	local Wep = ply:GetActiveWeapon()

	if BaseWars.Ents:Valid(Wep) then

		local Model = Wep:GetModel()
		local Class = Wep:GetClass()

		if BaseWars.Config.WeaponDropBlacklist[Class] then return false end

		local tr = {}

		tr.start = ply:EyePos()
		tr.endpos = tr.start + ply:GetAimVector() * 85
		tr.filter = ply

		tr = util.TraceLine(tr)

		local SpawnPos = tr.HitPos + BaseWars.Config.SpawnOffset
		local SpawnAng = ply:EyeAngles()

		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180
		SpawnAng.y = math.Round(SpawnAng.y / 45) * 45

		local Ent = ents.Create("bw_weapon")
			Ent.WeaponClass = Class
			Ent.Model = Model
			Ent:SetPos(SpawnPos)
			Ent:SetAngles(SpawnAng)
		Ent:Spawn()
		Ent:Activate()

		ply:StripWeapon(Class)

	end

end, false)

BaseWars.Commands.AddCommand({"steam", "sg", "group"}, function(ply)

	ply:SendLua([[gui.OpenURL"]] .. BaseWars.Config.SteamGroup .. [["]])

end, false)

BaseWars.Commands.AddCommand({"forums", "forum", "f"}, function(ply)

	ply:SendLua([[gui.OpenURL"]] .. BaseWars.Config.Forums .. [["]])

end, false)

BaseWars.Commands.AddCommand({"givemoney", "pay", "moneygive"}, function(caller, line, ply, amount)

	if not amount then return false, BaseWars.LANG.InvalidAmount end

	amount, ply = amount:Trim(), ply and ply:Trim() or ""

	if ply and isnumber(tonumber(ply)) then

		local amt, tar = ply, amount

		amount 	= amt
		ply 	= tar

	end

	local amt = amount:lower():Trim()
	if amt:match("nan") then return false, "Can't break the system mate" end

	amount = tonumber(amt) or 0
	
	if amount <= 0 then return false, false, "Can't break the system mate" end
	if amount > 0 and caller:GetMoney() < amount then return false, BaseWars.LANG.TooPoor end
	
	if ply ~= "" and ply ~= nil then

		ply = easylua.FindEntity(ply)

	else return false, BaseWars.LANG.InvalidPlayer end

	if not BaseWars.Ents:ValidPlayer(ply) then return false, BaseWars.LANG.InvalidPlayer end

	caller:TakeMoney(amount)
	ply:GiveMoney(amount)

	hook.Run("BaseWars_GiveMoney", caller, ply, amount)

	local Given = string.format(BaseWars.LANG.GivenMoney, caller:Nick(), BaseWars.NumberFormat(amount))
	local Gave = string.format(BaseWars.LANG.GaveMoney, ply:Nick(), BaseWars.NumberFormat(amount))

	caller:ChatPrint(Gave)
	ply:ChatPrint(Given)

end, false)

BaseWars.Commands.AddCommand({"bounty", "place", "placebounty"}, function(ply, line, who, amount)

	if not who then return false, BaseWars.LANG.InvalidPlayer end

	if not amount then return false, BaseWars.LANG.InvalidAmount end

	local Targ = easylua.FindEntity(who)

	if not BaseWars.Ents:ValidPlayer(Targ) then return false, BaseWars.LANG.InvalidPlayer end

	amount = amount:lower():Trim()
	if amt:match("nan") then return false, "Can't break the system mate" end
	
	amount = tonumber(amount) or 0
	
	if amount <= 0 then return false, false, "Can't break the system mate" end

	local result, error = Targ:PlaceBounty( ply, amount )

	if not result and error then
		return result, error
	end

end, false)
