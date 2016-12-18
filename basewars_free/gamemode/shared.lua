GM.Name 		= "BaseWars"
GM.Author 		= "Q2F2, Ghosty, Liquid, Tenrys, Trixter, User4992"
GM.Website 		= "http://hexahedronic.org/, http://hexahedronic.github.io/"
GM.Credits		= [[
Thanks to the following people:
	Q2F2				- Main backend dev.
	Ghosty			- Main frontent dev.
	Trixter			- Frontend + Several entities.
	Liquid			- Misc dev, good friend.
	Tenrys			- Misc dev, good friend also.
	Pyro-Fire		- Owner of LagNation, ideas ect.
	Devenger		- Twitch Weaponry 2
	User4992		- Fixes for random stuff.

This GM has been built from scratch with almost no traces of the original BaseWars existing.
]]
GM.License = [[
Copyright (c) 2015 Hexahedronic, ]] .. GM.Author .. [[

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- Thanks to whoever posted this, can't remember source.
function ents.FindInCone(cone_origin, cone_direction, cone_radius, cone_angle)

	local entities = ents.FindInSphere(cone_origin, cone_radius)
	local result = {}

	cone_direction:Normalize()

	local cos = math.cos(cone_angle)

	for _, entity in next, entities do

		local pos = entity:GetPos()
		local dir = pos - cone_origin
		dir:Normalize()

		local dot = cone_direction:Dot(dir)

		if dot > cos then

			table.insert(result, entity)

		end

	end

	return result

end

if BaseWars and BaseWars.Factions and table.Count(BaseWars.Factions.FactionTable) > 0 then

	__BASEWARS_FACTION_BACKUP = table.Copy(BaseWars.Factions.FactionTable)

end

if BaseWars and BaseWars.Bounty and table.Count(BaseWars.Bounty.BountyTable) > 0 then

	__BASEWARS_BOUNTY_BACKUP = table.Copy(BaseWars.Bounty.BountyTable)

end

BaseWars = BaseWars or {}

function BaseWars.IsXmasTime(day)

	local Month = tonumber(os.date("%m"))
	local Day	= tonumber(os.date("%d"))

	return Month == 12 and (not day or (Day == 24 or Day == 25))

end

local DefaultData = {

	__index = {

		Model = "models/props_c17/FurnitureToilet001a.mdl",
		Price = 0,
		ClassName = "prop_physics",
		ShouldFreeze = true,

	}

}

function BaseWars.GSL(t)

	if t.Drug then

		t.Model = "models/props_junk/PopCan01a.mdl"

	end

	if not t.Limit then

		t.Limit = BaseWars.Config.DefaultLimit

	end

	return setmetatable(t, DefaultData)

end

BASEWARS_NOTIFICATION_ADMIN = color_white
BASEWARS_NOTIFICATION_ERROR = Color(255, 0, 0, 255)
BASEWARS_NOTIFICATION_MONEY = Color(0, 255, 0, 255)
BASEWARS_NOTIFICATION_RAID 	= Color(255, 255, 0, 255)
BASEWARS_NOTIFICATION_GENRL = Color(255, 0, 255, 255)
BASEWARS_NOTIFICATION_DRUG	= Color(0, 255, 255, 255)

function BaseWars.PrinterCheck(ply)

	local Ents = ents.GetAll()

	local Raids = 0
	for k, v in next, Ents do

		if not BaseWars.Ents:Valid(v) or not v.CPPIGetOwner then continue end

		local Owner = v:CPPIGetOwner()
		if not BaseWars.Ents:ValidPlayer(Owner) or Owner ~= ply then continue end

		local Raidable = v.IsValidRaidable

		if Raidable then Raids = Raids + 1 end

	end

	if Raids >= BaseWars.Config.Raid.NeededPrinters then return true end

return false, BaseWars.LANG.NoPrinters end
hook.Add("PlayerIsRaidable", "BaseWars.Raidability.PrinterCheck", BaseWars.PrinterCheck)

local tag = "BaseWars.UTIL"

BaseWars.UTIL = {}

local colorRed 		= Color(255, 0, 0)
local colorBlue 	= Color(0, 0, 255)
local colorWhite 	= Color(255, 255, 255)

function BaseWars.UTIL.Log(...)

	MsgC(SERVER and colorRed or colorBlue, "[BaseWars] ", colorWhite, ...)
	MsgN("")

end

function BaseWars.UTIL.TimerAdv(name, spacing, reps, tickf, endf)

	timer.Create(name, spacing * reps, 1, endf)
	timer.Create(name .. ".Tick", spacing, reps, tickf)

end

function BaseWars.UTIL.TimerAdvDestroy(name)

	timer.Destroy(name)
	timer.Destroy(name .. ".Tick")

end

function BaseWars.UTIL.TimeParse(len)

	local len = math.abs(math.floor(len))

	local h = math.floor(len / 60 / 60)
	local m = math.floor(len / 60 - h * 60)
	local s = math.floor(len - m * 60 - h * 60 * 60)

	return string.format("%.2d:%.2d:%.2d", h, m, s)

end

local function Pay(ply, amt, name, own)

	ply:Notify(string.format(own and BaseWars.LANG.PayOutOwner or BaseWars.LANG.PayOut, BaseWars.NumberFormat(amt), name), BASEWARS_NOTIFICATION_GENRL)

	ply:GiveMoney(amt)

end

function BaseWars.UTIL.PayOut(ent, attacker, full, ret)

	if not BaseWars.Ents:Valid(ent) or not BaseWars.Ents:ValidPlayer(attacker) then return 0 end

	if not ent.CurrentValue then ErrorNoHalt("ERROR! NO CURRENT VALUE! CANNOT PAY OUT!\n") return 0 end

	local Owner = BaseWars.Ents:ValidOwner(ent)
	local Val = ent.CurrentValue * (not full and not ret and BaseWars.Config.DestroyReturn or 1)

	if Val ~= Val or Val == math.huge then

		ErrorNoHalt("NAN OR INF RETURN DETECTED! HALTING!\n")
		ErrorNoHalt("...INFINITE MONEY GLITCH PREVENTED!!!\n")

	return 0 end

	if ret then return Val end

	local Name = ent.PrintName or ent:GetClass()

	if ent.IsPrinter then Name = BaseWars.LANG.Level .. " " .. ent:GetLevel() .. " " .. Name end

	if attacker == Owner then

		Pay(Owner, Val, Name, true)

	return 0 end

	local Members = attacker:FactionMembers()
	local TeamAmt = table.Count(Members)
	local Involved = Owner and TeamAmt + 1 or TeamAmt

	local Fraction = math.floor(Val / Involved)

	if #Members > 1 then

		for k, v in next, Members do

			Pay(v, Fraction, Name)

		end

	else

		Pay(attacker, Fraction, Name)

	end

	if Owner then

		Pay(Owner, Fraction, Name, true)

	end

	return Val

end

function BaseWars.UTIL.RefundAll(ply, ret)

	if not ply and not ret then BaseWars.UTIL.Log("FULL SERVER REFUND IN PROGRESS!!!") end

	local RetTbl = {}

	if ret then

		for k, v in next, player.GetAll() do

			RetTbl[v:UniqueID()] = 0

		end

	end

	for k, v in next, ents.GetAll() do

		if not BaseWars.Ents:Valid(v) then continue end

		local Owner = BaseWars.Ents:ValidOwner(v)
		if not Owner or (ply and ply ~= Owner) then continue end

		if not v.CurrentValue then continue end

		if not ret then

			BaseWars.UTIL.PayOut(v, Owner, true, ret)
			v:Remove()

		else

			RetTbl[Owner:UniqueID()] = RetTbl[Owner:UniqueID()] + BaseWars.UTIL.PayOut(v, Owner, true, ret)

		end

	end

	return RetTbl

end

function BaseWars.UTIL.WriteCrashRollback(recover)

	if recover then

		if file.Exists("server_crashed.dat", "DATA") then

			BaseWars.UTIL.Log("Server crash detected, converting data rollbacks into refund files!")

		else

			return

		end

		local Files = file.Find("basewars_crashrollback/*_save.txt", "DATA")

		for k, v in next, Files do

			local FileName = v:gsub("_save.txt", "")
			local FileData = file.Read("basewars_crashrollback/" .. v, "DATA")

			file.Write("basewars_crashrollback/" .. FileName .. "_load.txt", FileData)

		end

	return end

	local RefundTable = BaseWars.UTIL.RefundAll(nil, true)

	for k, v in next, RefundTable do

		if not file.IsDir("basewars_crashrollback", "DATA") then file.CreateDir("basewars_crashrollback") end

		file.Write("basewars_crashrollback/" .. tostring(k) .. "_save.txt", v)

	end

	file.Write("server_crashed.dat", "")

end

function BaseWars.UTIL.RefundFromCrash(ply)

	local UID = ply:UniqueID()
	local FileName = "basewars_crashrollback/" .. UID .. "_load.txt"

	if file.Exists(FileName, "DATA") then

		local Money = file.Read(FileName, "DATA")
		Money = tonumber(Money)

		ply:ChatPrint(BaseWars.LANG.WelcomeBackCrash)
		ply:ChatPrint(string.format(BaseWars.LANG.Refunded, BaseWars.NumberFormat(Money)))

		BaseWars.UTIL.Log("Refunding ", ply, " for server crash previously.")
		ply:GiveMoney(Money)

		file.Delete(FileName)

	end

end

function BaseWars.UTIL.ClearRollbackFile(ply)

	local UID = ply:UniqueID()
	local FileName = "basewars_crashrollback/" .. UID .. "_save.txt"

	if file.Exists(FileName, "DATA") then file.Delete(FileName) end

end

function BaseWars.UTIL.SafeShutDown()

	BaseWars.UTIL.RefundAll()

	local Files = file.Find("basewars_crashrollback/*_save.txt", "DATA")

	for k, v in next, Files do

		file.Delete("basewars_crashrollback/" .. v)

	end

	file.Delete("server_crashed.dat")

end

function BaseWars.UTIL.FreezeAll()

	for k, v in next, ents.GetAll() do

		if not BaseWars.Ents:Valid(v) then continue end

		local Phys = v:GetPhysicsObject()
		if not BaseWars.Ents:Valid(Phys) then continue end

		Phys:EnableMotion(false)

	end

end

local NumTable = {
	[5] = {10^6 , "Million"},
	[4] = {10^9 , "Billion"},
	[3] = {10^12, "Trillion"},
	[2] = {10^15, "Quadrillion"},
	[1] = {10^18, "Quintillion"},
}

function BaseWars.NumberFormat(num)

	for i = 1, #NumTable do

		local Div = NumTable[i][1]
		local Str = NumTable[i][2]

		if num >= Div or num <= -Div then

			return string.Comma(math.Round(num / Div, 1)) .. " " .. Str

		end

	end

	return string.Comma(math.Round(num, 1))

end

local PlayersCol = Color(125, 125, 125, 255)
team.SetUp(1, "No Faction", PlayersCol)

function GM:PlayerNoClip(ply)

	local Admin = ply:IsAdmin()

	if SERVER then

		-- Second argument doesn't work??
		local State = ply:GetMoveType() == MOVETYPE_NOCLIP

		if aowl and not Admin and State and not ply.__is_being_physgunned then

			return true

		end

	end

	return Admin and not ply:InRaid() and (not aowl or ply.Unrestricted or ply:GetNWBool("Unrestricted"))

end

local function BlockInteraction(ply, ent, ret)

	if ent then

		if not BaseWars.Ents:Valid(ent) then return false end

		local Classes = BaseWars.Config.PhysgunBlockClasses
		if Classes[ent:GetClass()] then return false end

		local Owner = ent.CPPIGetOwner and ent:CPPIGetOwner()

		if BaseWars.Ents:ValidPlayer(ply) and ply:InRaid() then return false end
		if BaseWars.Ents:ValidPlayer(Owner) and Owner:InRaid() then return false end

	else

		if ply:InRaid() then return false end

	end

	return ret == nil or ret

end

local function IsAdmin(ply, ent, ret)

	if BlockInteraction(ply, ent, ret) == false then return false end

	return ply:IsAdmin()

end

function GM:PhysgunPickup(ply, ent)

	local Ret = self.BaseClass:PhysgunPickup(ply, ent)

	if ent:IsVehicle() then return IsAdmin(ply, ent, Ret) end

	return BlockInteraction(ply, ent, Ret)

end

function GM:CanPlayerUnfreeze(ply, ent, phys)

	local Ret = self.BaseClass:CanPlayerUnfreeze(ply, ent, phys)

	return BlockInteraction(ply, ent, Ret)

end

function GM:CanTool(ply, tr, tool)

	local Ret = self.BaseClass:CanTool(ply, tr, tool)

	if BaseWars.Config.BlockedTools[tool] then return IsAdmin(ply, ent, Ret) end
	if BaseWars.Ents:Valid(tr.Entity) and tr.Entity:GetClass():find("bw_") then return IsAdmin(ply, ent, Ret) end

	if SERVER then

		local Pos = tr.HitPos
		local HitString = math.floor(Pos.x) .. "," .. math.floor(Pos.y) .. "," .. math.floor(Pos.z)
		BaseWars.UTIL.Log("TOOL EVENT: ", ply, " -> ", tool, " on pos [", HitString, "]")

	end

	return BlockInteraction(ply, ent, Ret)

end

function GM:CanDrive()

	-- I'm fucking sick of this shit
	return false

end

function GM:OnPhysgunReload()

	-- Stop crashing our server faggots
	return false

end

function GM:CanProperty(ply, prop, ent, ...)

	local Ret = self.BaseClass:CanProperty(ply, prop, ent, ...)
	local Class = ent:GetClass()

	if prop == "persist" 	then return false end
	if prop == "ignite" 	then return false end
	if prop == "extinguish" then return IsAdmin(ply, ent, Ret) end

	if prop == "remover" and Class:find("bw_") then return IsAdmin(ply, ent, Ret) end

	return BlockInteraction(ply, ent, Ret)

end

function GM:GravGunPunt(ply, ent)

	local Ret = self.BaseClass:GravGunPunt(ply, ent)
	local Class = ent:GetClass()

	if ent:IsVehicle() then return false end

	if Class == "prop_physics" then return false end

	return BlockInteraction(ply, ent, Ret)

end

local NoSounds = {
	"vo/engineer_no01.mp3",
	"vo/engineer_no02.mp3",
	"vo/engineer_no03.mp3",
}
function GM:PlayerSpawnProp(ply, model)

	local Ret = self.BaseClass:PlayerSpawnProp(ply, model)

	local EscapedModel = model:lower():gsub("\\","/"):gsub("//", "/"):Trim()
	if BaseWars.Config.ModelBlacklist[EscapedModel] then

		ply:EmitSound(NoSounds[math.random(1, #NoSounds)], 140)

	return end

	Ret = (Ret == nil or Ret)

	if Ret then

		BaseWars.UTIL.Log("PROP EVENT: ", ply, " -> ", EscapedModel)

	end

	return Ret == nil or Ret

end
