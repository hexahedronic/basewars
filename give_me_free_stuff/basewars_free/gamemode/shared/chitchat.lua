--[[

	ChitChat
	script 			v 2
	implementation  v 1
	by Ghosty

	CURRENT Features:
		Chat modes
		Unlimited* chat chars

	PLANNED Features:
		Chat filtering
		Private messaging
		Lua code executor
		Tag system
		Themes
		Extendable tab system

	*1023 chars really, but who needs that many?

]]--

local Tag = "chitchat_msg"
local NET_SAFE_LIMIT = 65530 -- Playin' it safe
local GM = {}

chitchat = chitchat or {}

CHCH_SCRPVER = 2
CHCH_IMPLVER = 1

chitchat.Versions = {
	script 			= CHCH_SCRPVER,
	implementation 	= CHCH_IMPLVER,
}

local function GetIPR(ply)
	local ip = ply:IPAddress()
	return ip:gsub("(%d+%.%d+%.%d+)%..+","%1")
end

chitchat.MessageModes = {
	{ -- Global Chat
		PrintName 	= "GLOBAL",
		HideTag 	= true,
		Filter = function( s, r )
			return true	
		end,
	},
	{ -- Team Chat
		PrintName 	= "TEAM",
		Color		= Color(127, 190, 0),
		Filter		= function(s,r)
			return s:Team() == r:Team()
		end,
	},
	{ -- Local Chat (everyone with the same IP range as you)
		PrintName 	= "LOCAL",
		Color		= Color(102, 204, 255),
		Filter		= function(s,r)
			return GetIPR(s) == GetIPR(r)
		end,
	},
	{ -- Announcement
		PrintName 	= "ANNOUNCEMENT",
		Color 		= Color(255, 51, 0),
		ChatColor	= Color(255, 152, 152),
		Filter = function( s, r )
			return true	
		end,
	},
	{ -- Whisper (only people in a 72 unit radius can hear you)
		PrintName 	= "WHISPER",
		Color 		= Color(142, 142, 142),
		ChatColor	= Color(245, 245, 245),
		Filter 		= function (s,r)
			local pos1,pos2 = s:GetPos(),r:GetPos()
			return pos1:Distance(pos2) <= 72
		end,
	},
	{ -- Admins
		PrintName 	= "@ADMIN",
		Color 		= Color(102, 204, 255),
		Filter 		= function (s,r)
			return r:IsAdmin()
		end,
	},
	{
	 -- OOC
		PrintName 	= "OOC",
		Filter = function( s, r )
			return true	
		end,
	},
	{
	 -- LOOC, yell radius
		PrintName 	= "LOOC",
		ShowRank    = false,
		Color 			= Color(142, 142, 142),
		ChatColor 	= Color(232, 192, 192),
		Filter = function( s, r )
			return s:GetPos():DistToSqr(r:GetPos()) < 112500
		end,
	},
}

--[[
["donators"] = {
	["STEAM_0:1:66541847"] = "Mitzuya",
},
["moderators"] = {
	["STEAM_0:1:11838714"] = "TaillyLaundis",
	["STEAM_0:1:61234140"] = "creb",
	["STEAM_0:1:54664121"] = "TyroneMufasa",
},
["managers"] = {
	["STEAM_0:0:54576316"] = "AlanSugartits",
},
["owners"] = {
	["STEAM_0:1:74836666"] = "Trixter",
	["STEAM_0:1:62445445"] = "Q2F2",
	["STEAM_0:0:133411986"] = "MorganDrunkmanIWantedMilitia",
},
["developers"] = {
	["STEAM_0:0:80997988"] = "oplexz",
	["STEAM_0:1:32476157"] = "Tenrys",
	["STEAM_0:0:80669850"] = "user4992",
	["STEAM_0:0:155546951"] = "notoplex",
	["STEAM_0:0:42138604"] = "Liquid",
	["STEAM_0:0:62588856"] = "Ghosty",
	["STEAM_0:1:29543208"] = "ToastyEngineer",
},
]]

chitchat.Devs = {
	--Owners
	["STEAM_0:1:74836666"] = "Trixter",
	["STEAM_0:1:62445445"] = "Q2F2",
	["STEAM_0:0:133411986"] = "CakeShaked", --Trixter alt acc
	
	--Devs
	["STEAM_0:0:80997988"] = "oplexz",
	["STEAM_0:1:32476157"] = "Tenrys",
	["STEAM_0:0:80669850"] = "user4992",
	["STEAM_0:0:155546951"] = "notoplex",
	["STEAM_0:0:42138604"] = "Liquid",
	["STEAM_0:0:62588856"] = "Ghosty",
	["STEAM_0:1:29543208"] = "ToastyEngineer",
}

if SERVER then

	AddCSLuaFile()

	util.AddNetworkString(Tag)

	function GM:ChangeChatMode(ply,msg,msgmode)
		if msg:StartWith("@") then
			return 5,msg:gsub("^@","")
		end
		if msg:StartWith("//") then
			return 6,msg:gsub("^//%s?","")
		end

		if msg:StartWith("/ooc") then
			return 6,msg:gsub("^/ooc%s?","")
		end
		
		if msg:StartWith(".//") then
			return 7,msg:gsub("^%.// ?%s?","")
		end
	end

	net.Receive(Tag,function(len,ply)
		local msglen	= net.ReadUInt(10)
		local msg 	 	= net.ReadData(msglen)
		local msgmode 	= net.ReadUInt(6)

		local unmsg		= util.Decompress(msg)
		if not unmsg then
			Msg("[CHCH] ") print(ply," message failed to decompress!?")
			return
		end

		(epoe and epoe.RealMsgC or MsgC)(Color(255, 255, 0, 255), ply, color_white, ": ", unmsg, "\n")

		-- incoming terrible one-liners

		local msgrep	= gamemode.Call("PlayerSay",ply,unmsg,msgmode) -- you are an idiot if you use "== true" for unspecific things
		if msgrep == "" or msgrep == false then return end
		if msgrep then unmsg = msgrep end
		local newmode,m = gamemode.Call("ChangeChatMode",ply,unmsg,msgmode)
		if newmode == false then return end
		if newmode then msgmode = newmode end
		if m then unmsg = m end

		local msgmodefilt = chitchat.MessageModes[msgmode]
		if not msgmodefilt then return end -- silently fail
		msgmodefilt = msgmodefilt.Filter

		local plys = {}

		if msgmodefilt then
			for _,pl in next,player.GetHumans() do
				if msgmodefilt(ply,pl) then
					if table.HasValue(plys,pl) then continue end
					plys[#plys + 1] = pl
				end
			end
		end

		msg = util.Compress(unmsg)

		if not msg then
			Msg("[CHCH] ") print(ply," MESSAGE FAILED TO COMPRESS!? WTF???")
			return
		end

		msglen = #msg

		net.Start(Tag)
			net.WriteEntity(ply)
			net.WriteUInt(msglen,10)
			net.WriteData(msg,msglen)
			net.WriteUInt(msgmode,6)
			if net.BytesWritten() > NET_SAFE_LIMIT then
				Msg("[CHCH] ") print(ply," net message len over safe limits, bail")
				return
			end
		net.Send(plys)

	end)

else

	local timestm = CreateClientConVar("chitchat_timestamp","1")
	local shwsecs = CreateClientConVar("chitchat_timestamp_showseconds","0")
	local hours24 = CreateClientConVar("chitchat_timestamp_24hours","1")

	local function FormatZeroes(n)
		return n > 9 and "" .. n or "0" .. n
	end

	local function TimeStamp24Hours()
		local datetable = os.date("*t")
		local h,m,s = datetable.hour,datetable.min,datetable.sec
		return FormatZeroes(h) .. ":" .. FormatZeroes(m) .. (shwsecs:GetBool() and (":" .. FormatZeroes(m)) or "")
	end

	local function TimeStamp12Hours()
		local datetable = os.date("*t")
		local h,m,s = datetable.hour,datetable.min,datetable.sec
		local pm
		if h > 12 then
			h = h - 12
			pm = true
		end
		return FormatZeroes(h) .. ":" .. FormatZeroes(m) .. (shwsecs:GetBool() and (":" .. FormatZeroes(s)) or "") .. " " .. (pm and "PM" or "AM")
	end

	local purp = Color(102, 204, 255)

	local function TimeStamp()
		local ts = hours24:GetBool() and TimeStamp24Hours() or TimeStamp12Hours()
		local tbl = {
			purp,
			ts,
			" - ",
		}
		return tbl
	end

	local function NiceFormat(str)

		local Nice = str:lower()
		Nice = str:gsub("^%l", string.upper)

		return Nice

	end

	local white,gray = Color(255,255,255),Color(128,128,128)
	local red, blu, green = Color(225,0,0), Color(80, 200, 255), Color(133,208,142)

	local showranks = CreateConVar("cl_chitchat_showranks", "1", { FCVAR_ARCHIVE }, "Should we show player ranks when they talk? ex. \"[Owners] Q2F2: imgay\"")

	function GM:OnPlayerChat(ply,msg,mode,dead)

		local tbl = timestm:GetBool() and TimeStamp() or {}
		if mode == true  then mode = 2 end
		if mode == false then mode = 1 end

		local msgmode = chitchat.MessageModes[mode]

		tbl[#tbl + 1] = white
		if dead then
			tbl[#tbl + 1] = red
			tbl[#tbl + 1] = "*DEAD* "
		end

		if IsValid(ply) and ply:IsPlayer() then
			if chitchat.Devs[ply:SteamID()] then
			
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = green
				tbl[#tbl + 1] = "GM-Dev"
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "] "
			
			elseif (ply:IsAdmin() or (ply.IsMod and ply:IsMod())) and showranks:GetBool() then

				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = blu
				tbl[#tbl + 1] = NiceFormat(ply:GetUserGroup())
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "] "

			end

			if ply:GetUserGroup() == "donators" then

				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "["
				tbl[#tbl + 1] = green
				tbl[#tbl + 1] = "$"
				tbl[#tbl + 1] = gray
				tbl[#tbl + 1] = "] "

			end

			tbl[#tbl + 1] = team.GetColor(ply:Team())
			tbl[#tbl + 1] = ply:Nick()
		else
			tbl[#tbl + 1] = white
			tbl[#tbl + 1] = "Console"
		end

		local pname,tc,cc = "",white,white
		if msgmode then
			if not msgmode.HideTag then
				pname,tc,cc = msgmode.PrintName, msgmode.Color, msgmode.ChatColor
				tbl[#tbl + 1] = tc
				tbl[#tbl + 1] = " (" .. pname .. ")"
			end
		end

		tbl[#tbl + 1] = white
		tbl[#tbl + 1] = ": "
		tbl[#tbl + 1] = cc
		if msg:StartWith(">") and #msg > 1 then
			tbl[#tbl + 1] = Color(0,240,0)
		elseif msg:match("^[\"'].+[\"']") then
			tbl[#tbl + 1] = Color(255,200,200)
		end
		tbl[#tbl + 1] = msg

		chat.AddText(unpack(tbl))

		return true

	end

	net.Receive(Tag,function()
		local ply 	= net.ReadEntity()
		local len 	= net.ReadUInt(10)
		local data 	= net.ReadData(len)
		local mode 	= net.ReadUInt(6)

		data = util.Decompress(data)

		if not data then
			print("CHCH : Failed to decompress message.")
			return
		end

		local dead = (IsValid(ply) and ply:IsPlayer()) and (not ply:Alive()) or false

		gamemode.Call("OnPlayerChat",ply,data,mode,dead)
	end)

	function chitchat.Say(msg,msgmode)
		msgmode = tonumber(msgmode) or 1
		msg = util.Compress(msg)
		net.Start(Tag)
			net.WriteUInt(#msg,10)
			net.WriteData(msg,#msg)
			net.WriteUInt(msgmode,6)
		net.SendToServer()
	end

end

timer.Simple(0,function()
	local gm = GAMEMODE
	table.Merge(gm,GM)
end)
