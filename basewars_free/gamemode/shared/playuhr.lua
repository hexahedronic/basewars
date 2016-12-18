PlayTime = PlayTime or {}

local PLAYER = debug.getregistry().Player

if SERVER then
	
	PlayTime.LastThink = CurTime() + 1

	function PlayTime:Init()

		if not file.IsDir("basewars_time", "DATA") then file.CreateDir("basewars_time") end

	end

	function PlayTime:GetGlobalTimeFile(ply)

		local dir = "basewars_time/" .. ply:SteamID64()
		if not file.IsDir(dir, "DATA") then

			file.CreateDir( dir )
			file.Write(dir .. "/time.txt", "0")
			return 0

		else

			return tonumber(file.Read(dir .. "/time.txt"))

		end

	end

	function PlayTime:SetGlobalTimeFile(ply, time)

		local dir = "basewars_time/" .. ply:SteamID64()

		if not file.IsDir(dir, "DATA") then

			file.CreateDir(dir)
			file.Write(dir .. "/time.txt", "0")
	
		else

			file.Write(dir .. "/time.txt", time)

		end

	end

	hook.Add("Initialize", function()

		PlayTime:Init()
		PlayTime.LastThink = CurTime() + 1	--Not needed? Don't know

	end)

	hook.Add( "Think", "PlayTime.Think", function()

		if not (CurTime() > PlayTime.LastThink) then return end
		PlayTime.LastThink = CurTime() + 1
	
		for _, ply in next, player.GetAll() do

			ply:SetNW2String("SessionTime", tostring(ply:GetSessionTime()))
			ply:SetNW2String("GlobalTime", tostring(ply:GetPlayTime()))

		end

	end)

	hook.Add("PlayerInitialSpawn", "PlayTime.Connect", function(ply)

		ply.JoinTime = CurTime()
		ply.GlobalTime = PlayTime:GetGlobalTimeFile(ply)

	end)

	hook.Add( "PlayerDisconnected", "PlayTime.Disconnect", function(ply)

		PlayTime:SetGlobalTimeFile(ply, ply.GlobalTime + ply:GetSessionTime())

	end)
	
	hook.Add( "ShutDown", "PlayTime.ShutDown", function()
		
		for _, ply, next in pairs( player.GetAll() ) do
		
			PlayTime:SetGlobalTimeFile(ply, ply.GlobalTime + ply:GetSessionTime())
			
		end
		
	end	)

end 

function PLAYER:GetPlayTime()

	if SERVER then

		return math.Round((self.GlobalTime or 0) + self:GetSessionTime())
	else

		return tonumber(self:GetNW2String("GlobalTime", "0")) or 0

	end

end

function PLAYER:GetPlayTimeTable()

	local tbl = {}
	local time = self:GetPlayTime() or 0

	tbl.h = math.floor(time / 60 / 60)
	tbl.m = math.floor(time / 60) % 60
	tbl.s = math.floor(time) % 60
	
	return tbl

end

function PLAYER:GetSessionTime()

	if SERVER then

		return math.Round(CurTime() - self.JoinTime)

	else

		return tonumber(self:GetNW2String("SessionTime", "0"))

	end

end

function PLAYER:GetSessionTable()

	local tbl = {}
	local time = self:GetSessionTime() or 0
	
	tbl.h = math.floor(time / 60 / 60)
	tbl.m = math.floor(time / 60) % 60
	tbl.s = math.floor(time) % 60
	
	return tbl

end
