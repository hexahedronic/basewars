MODULE.Name 	= "Factions"
MODULE.Author 	= "Q2F2 & Ghosty"
MODULE.FactionTable = {}

local tag = "BaseWars.Factions"
local PLAYER = debug.getregistry().Player

function MODULE:__INIT()

	if __BASEWARS_FACTION_BACKUP then

		BaseWars.UTIL.Log("Detected faction backup. ATTEMPTING TO RESTORE.")
		self.FactionTable = table.Copy(__BASEWARS_FACTION_BACKUP)

		__BASEWARS_FACTION_BACKUP = nil

		self.FactionTable.__id = table.Count(self.FactionTable) - 1

	else

		self.FactionTable.__id = 1

	end

end

if SERVER then

	util.AddNetworkString(tag)
	util.AddNetworkString(tag..".Teams")

	-- Modes:
	-- Set -> 0
	-- Leave -> 1
	-- Create -> 2

	function MODULE:HandleNetMessage(len, ply)

		local Mode = net.ReadUInt(2)

		if Mode == 0 then

			local value = net.ReadString()
			local password = net.ReadString()

			self:Set(ply, value, password, false)

		elseif Mode == 1 then

			local disband = net.ReadBool()

			self:Leave(ply, disband)

		elseif Mode == 2 then

			local value = net.ReadString()
			local password = net.ReadString()
			local color = net.ReadColor()

			if password:Trim() == "" then password = nil end

			self:Create(ply, value, password, color)

		end

	end

	net.Receive(tag, Curry(MODULE.HandleNetMessage))

else

	function MODULE:ReadTeams()

		local tbl = net.ReadTable()

		if type(tbl[1]) == "table" then

			for _, tbl2 in next, tbl do
				local teamid = tbl2.teamid
				local name = tbl2.name
				local color = tbl2.color
				team.SetUp(teamid, name, color)
			end

		else

			local teamid = tbl.teamid
			local name = tbl.name
			local color = tbl.color

			if not teamid or not name or not color then

				ErrorNoHalt("Error making team -> ", teamid, name, color)

			return end

			team.SetUp(teamid, name, color)

		end

	end

	net.Receive(tag .. ".Teams", Curry(MODULE.ReadTeams))

end

function MODULE:Get(ply)

	return ply:GetNW2String(tag, "")

end

PLAYER.GetFaction = Curry(MODULE.Get)

function MODULE:Set(ply, value, password, force)

	if not value or not isstring(value) then

		ErrorNoHalt("Error setting Faction, invalid value.")
		debug.Trace()

		return

	end

	if CLIENT then

		net.Start(tag)
			net.WriteUInt(0, 2)
			net.WriteString(value)
			net.WriteString(password or "")
		net.SendToServer()

		return

	end

	local Table = BaseWars.Factions.FactionTable
	local Faction = Table[value]

	if not Faction then

		ply:Notify(BaseWars.LANG.FactionNotExist, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	local Call, Error = hook.Run("CanJoinFaction", ply, value, password)

	if Call == false then

		ply:Notify(Error, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	local Lead = ply:InFaction(nil, true)

	if ply:InFaction() then

		ply:LeaveFaction(Lead)

	end

	if Faction.password and Faction.password ~= password and not force then

		ply:Notify(BaseWars.LANG.FactionWrongPass, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	Faction.members[ply:SteamID()] = ply
	ply:SetNW2String(tag, value)
	ply:SetTeam(Faction.teamid)

end
local setFaction = Curry(MODULE.Set)
PLAYER.SetFaction = setFaction
PLAYER.JoinFaction = setFaction

function MODULE:Leave(ply, disband, forcedisband)

	if CLIENT then

		net.Start(tag)
			net.WriteUInt(1, 2)
			net.WriteBool(disband)
		net.SendToServer()

		return

	end

	local Table = BaseWars.Factions.FactionTable
	local Fac = ply:GetFaction()
	local Faction = Table[Fac]

	if not Faction then

		ply:SetNW2String(tag, "")
		ply:SetNW2Bool( tag..".Leader", false )

		ply:SetTeam(1)

		return

	end

	local Call, Error = hook.Run("CanLeaveFaction", ply, disband)

	if Call == false then

		ply:Notify(Error, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	if not forcedisband and disband and Faction.leader ~= ply:SteamID() then

		disband = false

	end

	if forcedisband or disband then

		BaseWars.UTIL.Log("Faction disband for ", Fac, ". ", table.Count(Faction.members), " members.")

		for k, v in next, Faction.members do

			if v == ply then continue end

			if not BaseWars.Ents:ValidPlayer(v) then continue end

			self:Leave(v, false)

		end

		ply:SetNW2String(tag, "")
		ply:SetNW2Bool(tag .. ".Leader", false)

		BaseWars.Factions.FactionTable[Fac] = nil

		ply:SetTeam( 1 )

	else

		if Faction.leader == ply:SteamID() then

			ply:Notify(BaseWars.LANG.FactionCantLeaveLeader, BASEWARS_NOTIFICATION_ERROR)

			return

		end

		ply:SetNW2String(tag, "")
		ply:SetNW2Bool(tag .. ".Leader", false)

		BaseWars.Factions.FactionTable[Fac].members[ply:SteamID()] = nil

		ply:SetTeam(1)

		if table.Count(Table[Fac].members) < 1 then

			BaseWars.UTIL.Log("Faction disband for ", Fac, ". All members left. <Leader must have D/C'ed>")

			BaseWars.Factions.FactionTable[Fac] = nil

		end

	end

end
PLAYER.LeaveFaction = Curry(MODULE.Leave)

function MODULE:Members(ply)

	if CLIENT then return end

	local Table = BaseWars.Factions.FactionTable
	local Fac = ply:GetFaction()
	local Faction = Table[Fac]

	if not Faction then return {[ply:SteamID()] = ply} end

	return Faction.members

end
PLAYER.FactionMembers = Curry(MODULE.Members)

function MODULE:ChangePass(ply, newpass)

	if not newpass or not isstring(newpass) then return end

	if CLIENT then

		-- Do netmessage here
		-- check newpass as string

	return end

	if not ply:InFaction() then

		ply:Notify(BaseWars.LANG.FactionNotExist, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	local Name = ply:GetFaction()
	local Table = BaseWars.Factions.FactionTable
	local Faction = Table[Name]

	if not Table[Name] then

		ply:Notify(BaseWars.LANG.FactionNotExist, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	if Faction.leader ~= ply:SteamID() then

		ply:Notify(BaseWars.LANG.FactionCantPassword, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	Faction.password = newpass

end

function MODULE:InFaction(ply, name, leader)

	local Fac = ply:GetFaction()

	if CLIENT then

		-- Client cant check if they are the leader due to how it works
		if not name then

			return Fac ~= ""

		end

	return Fac == name end

	local Table = BaseWars.Factions.FactionTable
	local Faction = Table[Fac]

	local Leader = (not leader or Faction and Faction.leader == ply:SteamID())

	if not name then

		return Fac ~= "" and Leader

	end

	return Fac == name and Leader

end
PLAYER.InFaction = Curry(MODULE.InFaction)

function MODULE:FactionExist(name)

	if CLIENT then

		ErrorNoHalt("Error checking Faction, cannot check clienside.")
		debug.Trace()

		return

	end

	local Table = BaseWars.Factions.FactionTable

	if Table[name] then

		return true

	end

	return false

end

function MODULE:IsEnemy(ply, ply2)

	if ply == ply2 then return false end
	if ply:InFaction() and ply2:InFaction(ply:GetFaction()) then return false end
	if ply.UnRestricted or ply:GetNWBool("UnRestricted") then return false end

	return true

end
PLAYER.IsEnemy = Curry(MODULE.IsEnemy)

function MODULE:SendClientTeamData(ply)

	if table.Count(BaseWars.Factions.FactionTable) <= 1 then return end

	local datas = {}

	for name, data in next, BaseWars.Factions.FactionTable do

		if not istable(data) then continue end

		table.insert(datas, {name = name, teamid = data.teamid,color = data.color})

	end
	net.Start(tag .. ".Teams")
		net.WriteTable(datas)
	net.Send(ply)

end
hook.Add("PlayerInitialSpawn", tag .. ".Teams", Curry(MODULE.SendClientTeamData))

function MODULE:Clean(ply)

	self:Leave(ply, true)

end
hook.Add("PlayerDisconnected", tag .. ".Clean", Curry(MODULE.Clean))

function MODULE:Create(ply, name, password, color)

	color = color or HSVToColor(math.random(359), math.Rand(0.8, 1), math.Rand(0.8, 1))

	if not name or not isstring(name) or (password and not isstring(password)) then

		ErrorNoHalt("Error creating Faction, invalid name or password.")
		debug.Trace()

		return

	end

	if CLIENT then

		net.Start(tag)
			net.WriteUInt(2, 2)
			net.WriteString(name)
			net.WriteString(password or "")
			net.WriteColor(color)
		net.SendToServer()

		return

	end

	local Table = BaseWars.Factions.FactionTable

	if Table[name] then

		ply:Notify(BaseWars.LANG.FactionNameTaken, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	local Call, Error = hook.Run("CanCreateFaction", ply, name, password)

	if Call == false then

		ply:Notify(Error, BASEWARS_NOTIFICATION_ERROR)

		return

	end

	BaseWars.UTIL.Log("Faction created for ", name, ". Leader: ", ply:Nick(), ". Password: ", (password ~= "" and password or "<NONE>"), ".")

	local teamid = self:GetEmptyTeamID() + 1

	Table[name] = {
		leader = ply:SteamID(),
		password = password,
		members = {},
		teamid = teamid or 1,
		color = color,
	}

	team.SetUp(teamid, name, color)
	self:SendFactionData(teamid, name, color)
	ply:SetNW2Bool(tag .. ".Leader", true)

	ply:SetFaction(name, nil, true)

end
PLAYER.CreateFaction = Curry(MODULE.Create)

function MODULE:SendFactionData(teamid, name, color)

	net.Start( tag..".Teams" )
		net.WriteTable({teamid = teamid, name = name, color = color})
	net.Broadcast()

end

function MODULE:GetEmptyTeamID()

	self.FactionTable.__id = (self.FactionTable.__id or 1) + 1

	return self.FactionTable.__id

end
