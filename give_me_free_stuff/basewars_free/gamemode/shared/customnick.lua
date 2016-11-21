local Tag = "nname"
local Tag_remove = "nname_destroy"
local Tag_pdata = "playernname"

local select        = select

local string_byte   = string.byte
local string_gmatch = string.gmatch
local string_gsub   = string.gsub
local string_sub    = string.sub

local utf8 = {}

function utf8.byte(char, offset)

	if char == "" then return -1 end

	offset = offset or 1
	
	local byte = string_byte(char, offset)
	local length = 1

	if byte >= 128 then

		-- multi-byte sequence
		if byte >= 240 then

			-- 4 byte sequence
			length = 4

			if #char < 4 then return -1, length end

			byte = (byte % 8) * 262144
			byte = byte + (string_byte(char, offset + 1) % 64) * 4096
			byte = byte + (string_byte(char, offset + 2) % 64) * 64
			byte = byte + (string_byte(char, offset + 3) % 64)

		elseif byte >= 224 then

			-- 3 byte sequence
			length = 3

			if #char < 3 then return -1, length end

			byte = (byte % 16) * 4096
			byte = byte + (string_byte(char, offset + 1) % 64) * 64
			byte = byte + (string_byte(char, offset + 2) % 64)

		elseif byte >= 192 then

			-- 2 byte sequence
			length = 2

			if #char < 2 then return -1, length end

			byte = (byte % 32) * 64
			byte = byte + (string_byte(char, offset + 1) % 64)

		else

			-- this is a continuation byte
			-- invalid sequence
			byte = -1

		end

	else

		-- single byte sequence

	end

	return byte, length
end

-- Taken from http://cakesaddons.googlecode.com/svn/trunk/glib/lua/glib/unicode/utf8.lua
function utf8.length(str)

	local _, length = string_gsub(str, "[^\128-\191]", "")
	return length

end

-- Taken from http://www.curse.com/addons/wow/utf8/546587
function utf8.sub(str, i, j)

	j = j or -1

	local pos = 1
	local bytes = #str
	local length = 0

	-- only set l if i or j is negative
	local l = (i >= 0 and j >= 0) or utf8.length(str)
	local start_char = (i >= 0) and i or l + i + 1
	local end_char   = (j >= 0) and j or l + j + 1

	-- can't have start before end!
	if start_char > end_char then

		return ""

	end

	-- byte offsets to pass to string.sub
	local start_byte, end_byte = 1, bytes

	while pos <= bytes do

		length = length + 1

		if length == start_char then

			start_byte = pos

		end

		pos = pos + select(2, utf8.byte(str, pos))

		if length == end_char then

			end_byte = pos - 1
			break

		end

	end

	return string_sub(str, start_byte, end_byte)
end

function utf8.totable(str)

	local tbl = {}
	
	for uchar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do

		tbl[#tbl + 1] = uchar

	end
	
	return tbl

end

local PLY = debug.getregistry().Player

PLY.OldNick = PLY.OldNick or PLY.Nick
PLY.RealName = PLY.OldNick
PLY.RealNick = PLY.OldNick
PLY.EngineNick = PLY.EngineNick

local Nicks = {}

if SERVER then

	AddCSLuaFile()

	util.AddNetworkString(Tag)
	util.AddNetworkString(Tag_remove)

	local function MakeValidNick(n)

		if not isstring(n) then return end

		n = utf8.sub(n, 1, 900)

		return n

	end

	local function NickRestrict(n)

		n = utf8.sub(n, 1, 100)
		n = n:Trim()

		if n == "" then return end

		return n

	end

	local function NetworkNick(ply, receivers, nick, sync)

		net.Start(Tag)

			net.WriteEntity(ply)
			net.WriteString(nick)
			net.WriteBool(not not sync)

			local bytes = net.BytesWritten()
			if bytes > 65500 then error("NET PANIC: TOO MANY BYTES WRITTEN (" .. bytes .. ")") end

		net[receivers and "Send" or "Broadcast"](receivers)

	end

	function PLY:SetNick(str,sync)

		local eid = self:EntIndex()

		if not str then

			if not Nicks[eid] then return end

			self:RemovePData(Tag_pdata)
			Nicks[eid] = nil
			
			net.Start(Tag_remove)

				net.WriteEntity(self)

			net.Broadcast()

		return end

		str = MakeValidNick(str)
		if not str then return end

		NetworkNick(self, nil, str, sync or false)
		Nicks[eid] = str
		self:SetPData(Tag_pdata, str)

	end

	hook.Add("PlayerInitialSpawn", "nname_spawn_network", function(ply)

		timer.Create("nname_gaymemes" .. ply:SteamID(), 0.5, 10, function()

			if not IsValid(ply) then return end

			for _, pl in next, player.GetAll() do
				
				if Nicks[pl:EntIndex()] then
					
					NetworkNick(pl, ply, Nicks[pl:EntIndex()], true)

				end

			end

		end)

		local nick = ply:GetPData(Tag_pdata)

		if nick then
			
			ply:SetNick(nick)

		end

	end)

	hook.Add("PlayerDisconnected", "nname_disconnect", function(ply)

		Nicks[ply:EntIndex()] = nil

	end)

	net.Receive(Tag, function(_, ply)

		local str = net.ReadString()

		str = NickRestrict(str)
		ply:SetNick(str)

	end)

	net.Receive(Tag_remove, function(_, ply)

		ply:SetNick()

	end)

	function PLY:FixNick()

		self:SetNick(self:GetPData(Tag_pdata), true)

	end

	if table.Count(player.GetAll()) > 0 then
		
		for _, ply in next, player.GetAll() do
			
			ply:FixNick()

		end

	end

	function PLY:Nick()

		return Nicks[self:EntIndex()] or self:OldNick() or "unnamed"

	end	

	PLY.ChangeNick = PLY.SetNick

else

	local M = {}

	local r = rawget
	function M:__index(k)

		for val in next, self do
			
			if not IsValid(val) then self[val] = nil end

		end

		return r(self, k)

	end

	setmetatable(Nicks, M)

	local white = Color(255, 255, 255)
	local function NickChange_Chat(ply, oldnick, newnick)

		if oldnick == newnick then return end

		local tc = Color(255, 255, 0)

		if ply then
			
			tc = team.GetColor(ply:Team())

		end

		local tbl = {tc}

		tbl[#tbl + 1] = oldnick
		tbl[#tbl + 1] = white
		tbl[#tbl + 1] = " is now called "
		tbl[#tbl + 1] = tc
		tbl[#tbl + 1] = newnick
		tbl[#tbl + 1] = white
		tbl[#tbl + 1] = "."

		timer.Simple(0.1, function()

			chat.AddText(unpack(tbl))

		end)

	end

	net.Receive(Tag, function()

		local ply = net.ReadEntity()

		if not (ply:IsValid() and ply:IsPlayer()) then return end

		local str = net.ReadString()
		local sync = net.ReadBool()

		if not sync then NickChange_Chat(ply, ply:Nick(), str) end
		Nicks[ply] = str

	end)

	net.Receive(Tag_remove, function()

		local ply = net.ReadEntity()

		if not (ply:IsValid() and ply:IsPlayer()) then return end

		NickChange_Chat(ply, Nicks[ply], ply:OldNick())
		Nicks[ply] = nil

	end)

	function PLY:SetNick(str)

		if not self == LocalPlayer() then return end

		if not str or str:Trim() == "" then

			net.Start(Tag_remove)
			net.SendToServer()

		return end

		net.Start(Tag)

			net.WriteString(str)
			local bytes = net.BytesWritten()
			if bytes > 65500 then error("NET PANIC: TOO MANY BYTES WRITTEN (" .. bytes .. ")") end

		net.SendToServer()		

	end

	function PLY:Nick()

		return Nicks[self] or self:OldNick() or "unnamed"

	end

end

PLY.GetNick = PLY.Nick
PLY.Name = PLY.Nick
