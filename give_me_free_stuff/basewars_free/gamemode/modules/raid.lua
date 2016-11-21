MODULE.Name 	= "Raid"
MODULE.Author 	= "Q2F2 & Ghosty"

local tag = "BaseWars.Raid"
local PLAYER = debug.getregistry().Player

if SERVER then

	util.AddNetworkString(tag)
	
else

	surface.CreateFont(tag, {
		font = "Roboto",
		size = 30,
		weight = 800,
		antialias = true
	})
	
end
	
function MODULE:HandleNetMessage(len, ply)

	local Mode = net.ReadUInt(2)
	
	if CLIENT then
	
		local ply = LocalPlayer()
	
		if Mode == 0 then
		
			local time 		= net.ReadInt(16)
			local versus 	= net.ReadEntity()
			local versus2 	= net.ReadEntity()
			local faction	= net.ReadBool()
		
			self:CLIENT_SetupRaid(time, versus, versus2, faction)
		
		elseif Mode == 1 then
		
			self:EndRaid()
			
		end
	
	else
	
		if Mode == 0 then
		
			local versus 	= net.ReadEntity()
			
			self:Start(ply, versus)
			
		elseif Mode == 1 then
		
			self:ConceedRaid(ply)
			
		end
	
	end
	
end
net.Receive(tag, Curry(MODULE.HandleNetMessage))

local TimeRemaining = 0
local IsFaction		= false
local Participant1	= nil
local Participant2	= nil
local P1Faction		= nil
local P2Faction		= nil

function MODULE:GetP1()

	return Participant1

end

function MODULE:GetP2()

	return Participant2

end

function MODULE:IsFaction()

	return IsFaction

end

function MODULE:CheckForNULL()

	if not IsFaction and (not BaseWars.Ents:ValidPlayer(Participant1) or not BaseWars.Ents:ValidPlayer(Participant2)) then
	
		return false
		
	end
	
	if IsFaction and SERVER then
	
		local F1 = BaseWars.Factions:FactionExist(P1Faction)
		local F2 = BaseWars.Factions:FactionExist(P2Faction)
		
		if not F1 or not F2 then
		
			return false
			
		end
	
	end
	
	return true
	
end

function MODULE:IsOnGoing()

	return TimeRemaining > 0 and TimeRemaining

end

function MODULE:PlayerInvolved(ply)

	if not self:IsOnGoing() then
	
		return false
		
	end
	
	if Participant1 == ply or Participant2 == ply then
	
		return true
		
	end
	
	if IsFaction and (ply:InFaction(P1Faction) or ply:InFaction(P2Faction)) then
	
		return true
		
	end
	
	return false
	
end
PLAYER.InRaid = Curry(MODULE.PlayerInvolved)

function MODULE:CheckRaidable(ply, nocool, fac)

	local Table = BaseWars.Factions.FactionTable
	local Faction = Table[ply:GetFaction()]

	if not nocool then

		local Cool = CurTime() - (Faction and Faction.__RaidCoolDown or ply.__RaidCoolDown or 0)
		local Left = math.floor(BaseWars.Config.Raid.CoolDownTime - Cool)
	
		if Cool < BaseWars.Config.Raid.CoolDownTime then return false, BaseWars.LANG.OnCoolDown .. " (" .. Left .. " " .. BaseWars.LANG.Seconds .. " " .. BaseWars.LANG.Remaining .. ")" end
		
	end

	local Call, Message = hook.Run("PlayerIsRaidable", ply)
	
	if Call == false and Faction then
	
		for k, v in next, Faction.members do
		
			Call, Message = hook.Run("PlayerIsRaidable", v)
			
			if Call == false then break end
			
		end
		
	end
	
	if Call == false then
	
		return false, Message
		
	end

	return true
	
end
PLAYER.Raidable = Curry(MODULE.CheckRaidable)

function MODULE:TimerTick()

	if SERVER then
	
		if not self:CheckForNULL() then
		
			self:EndRaid()
			
			return
			
		end
	
	end
	
	if TimeRemaining > 0 then
	
		TimeRemaining = TimeRemaining - 1
		
	end
	
end
local tick = Curry(MODULE.TimerTick)

function MODULE:TimerEnd()

	self:EndRaid()
	
end
local fend = Curry(MODULE.TimerEnd)

function MODULE:Start(ply, target)

	if not target or not target:IsPlayer() then
	
		ErrorNoHalt("RaidStart, invalid target.")
		debug.Trace()
		
		return
		
	end
	
	if CLIENT then
	
		net.Start(tag)
			net.WriteUInt(0, 2)
			net.WriteEntity(target)
		net.SendToServer()
		
		return
	
	end

	if self:IsOnGoing() then
	
		ply:Notify(BaseWars.LANG.RaidOngoing, BASEWARS_NOTIFICATION_RAID)
		
		return
		
	end
	
	if ply == target then
	
		ply:Notify(BaseWars.LANG.CantRaidSelf, BASEWARS_NOTIFICATION_RAID)
		
		return
		
	end
	
	if ply:InFaction() and not target:InFaction() then
	
		ply:Notify(BaseWars.LANG.RaidTargNoFac, BASEWARS_NOTIFICATION_RAID)
	
		return
		
	end
	
	if target:InFaction() and not ply:InFaction() then
	
		ply:Notify(BaseWars.LANG.RaidSelfNoFac, BASEWARS_NOTIFICATION_RAID)
	
		return
		
	end
	
	IsFaction = ply:InFaction()
	
	local Ret, Msg

	Ret, Msg = self:CheckRaidable(ply, true, IsFaction)
	if not Ret then
	
		ply:Notify(string.format(BaseWars.LANG.RaidSelfUnraidable, Msg or "UNKNOWN!"), BASEWARS_NOTIFICATION_RAID)
		
		return
		
	end
	
	Ret, Msg = self:CheckRaidable(target, false, IsFaction)
	if not Ret then
	
		ply:Notify(string.format(BaseWars.LANG.RaidTargetUnraidable, Msg or "UNKNOWN!"), BASEWARS_NOTIFICATION_RAID)
		
		return
		
	end
	
	if IsFaction and target:InFaction(ply:GetFaction()) then
	
		ply:Notify(BaseWars.LANG.CantRaidSelf, BASEWARS_NOTIFICATION_RAID)
	
		return
		
	end

	hook.Run("RaidStart")
	
	Participant1 = ply
	Participant2 = target
	
	P1Faction = Participant1:GetFaction()
	P2Faction = Participant2:GetFaction()
	
	local Table = BaseWars.Factions.FactionTable
	local Faction = Table[P1Faction]
	
	if Faction then Faction.__RaidCoolDown = 0 else ply.__RaidCoolDown = 0 end
	
	TimeRemaining = BaseWars.Config.Raid.Time
	
	local Faction2 = Table[P2Faction]
	
	if Faction2 then Faction2.__RaidCoolDown = CurTime() + TimeRemaining else target.__RaidCoolDown = CurTime() + TimeRemaining end
	
	net.Start(tag)
		net.WriteUInt(0, 2)
		net.WriteInt(TimeRemaining, 16)
		net.WriteEntity(ply)
		net.WriteEntity(target)
		net.WriteBool(IsFaction)
	net.Broadcast()
	
	BaseWars.UTIL.TimerAdv(tag, 1, BaseWars.Config.Raid.Time, tick, fend)
	
	local name1, name2 = self:GetVersus()
	
	BaseWars.Util_Player:NotificationAll(string.format(BaseWars.LANG.RaidStart, name1, name2), BASEWARS_NOTIFICATION_RAID)

end
PLAYER.StartRaid = Curry(MODULE.Start)

function MODULE:ConceedRaid(ply)

	if not ply:InRaid() then return end
	if IsFaction and not ply:InFaction(P1Faction, true) then return end
	if not IsFaction and ply ~= Participant1 then return end

	if CLIENT then
	
		net.Start(tag)
			net.WriteUInt(1, 2)
		net.SendToServer()
	
	return end
	
	self:EndRaid()
	
end
PLAYER.ConceedRaid = Curry(MODULE.ConceedRaid)

function MODULE:GetVersus()

	if not self:CheckForNULL() then
	
		ErrorNoHalt("NULL CHECK FAILED FOR RAID!\n")
		return "<NONE>", "<NONE>"
		
	end
	
	local TrimTo = 21
	local name1, name2
	
	if IsFaction then
		
		name1 = Participant1:GetFaction():Trim()
		name2 = Participant2:GetFaction():Trim()
		
	else
	
		name1 = Participant1:Nick():Trim()
		name2 = Participant2:Nick():Trim()
		
	end
	
	if utf8.sub then
	
		name1 = utf8.sub(name1, 1, TrimTo):Trim() .. (utf8.len(name1) > TrimTo and "..." or "")
		name2 = utf8.sub(name2, 1, TrimTo):Trim() .. (utf8.len(name2) > TrimTo and "..." or "")

	else
		
		name1 = name1:sub(1, TrimTo):Trim() .. (string.len(name1) > TrimTo and "..." or "")
		name2 = name2:sub(1, TrimTo):Trim() .. (string.len(name2) > TrimTo and "..." or "")
	
	end
	
	return name1, name2

end

function MODULE:EndRaid()

	if not self:IsOnGoing() then return end
	
	hook.Run("RaidEnd")
	
	if SERVER then
	
		net.Start(tag)
			net.WriteUInt(1, 2)
		net.Broadcast()
		
		local name1, name2 = self:GetVersus()
		BaseWars.Util_Player:NotificationAll(string.format(BaseWars.LANG.RaidOver, name1, name2), BASEWARS_NOTIFICATION_RAID)
		
	end

	TimeRemaining = 0
	Participant1 = nil
	Participant2 = nil
	
	P1Faction = nil
	P2Faction = nil
	
	BaseWars.UTIL.TimerAdvDestroy(tag)

end

local PaintVS = ""

function MODULE:CLIENT_SetupRaid(t, versus, versus2, faction)

	hook.Run("RaidStart")

	TimeRemaining 	= t
	IsFaction		= faction
	Participant1	= versus
	Participant2	= versus2
	
	local name1, name2 = self:GetVersus()
	
	P1Faction = Participant1:GetFaction()
	P2Faction = Participant2:GetFaction()
	
	PaintVS = name1 .. " vs " .. name2
	
	--chat.AddText("STARTING RAID TIMER CLIENTSIDE", tostring(TimeRemaining))
	
	BaseWars.UTIL.TimerAdv(tag, 1, BaseWars.Config.Raid.Time, tick, function() end)

end

function MODULE:Paint()

	if not self:IsOnGoing() then return end
	
	surface.SetTextColor(color_white)

	surface.SetFont(tag)
	local w, h = surface.GetTextSize(PaintVS)
	
	surface.SetTextPos(ScrW() / 2 - w / 2, ScrH() - h - 1)
	surface.DrawText(PaintVS)
	
	local text = tostring(TimeRemaining) .. "s Remaining"
	
	local w2, h2 = surface.GetTextSize(text)
	
	surface.SetTextPos(ScrW() / 2 - w2 / 2, ScrH() - h - h2 - 2)
	surface.DrawText(text)
	
end
hook.Add("HUDPaint", tag .. ".Paint", Curry(MODULE.Paint))

local function FalseInRaid(ply)

	if ply:InRaid() then return false, BaseWars.LANG.RaidNoFaction end
	
end
hook.Add("CanCreateFaction", tag, FalseInRaid)
hook.Add("CanLeaveFaction", tag, FalseInRaid)
hook.Add("CanJoinFaction", tag, FalseInRaid)
