MODULE.Name 	= "Karma"
MODULE.Author 	= "Q2F2 & Ghosty"

local tag = "BaseWars.Karma"
local tag_escaped = "basewars_karma"
local PLAYER = debug.getregistry().Player

local function isPlayer(ply)

	return (IsValid(ply) and ply:IsPlayer())
	
end

function MODULE:Get(ply)

	if SERVER then
	
		local dirName = self:Init(ply)
		local karma = tonumber(file.Read(tag_escaped .. "/" .. dirName .. "/karma.txt", "DATA"))
		return karma
		
	elseif CLIENT then
	
		return tonumber(ply:GetNWString(tag)) or 0
		
	end
	
end
PLAYER.GetKarma = Curry(MODULE.Get)

if SERVER then

	function MODULE:Init(ply)
	
		local dirName = isPlayer(ply) and ply:SteamID64() or (isstring(ply) and ply or nil)
		
		if not file.IsDir(tag_escaped .. "/" .. dirName, "DATA") then file.CreateDir(tag_escaped .. "/" .. dirName) end
		if not file.Exists(tag_escaped .. "/" .. dirName .. "/karma.txt", "DATA") then file.Write(tag_escaped .. "/" .. dirName .. "/karma.txt", 0) end
		
		return dirName
		
	end
	PLAYER.InitKarma = Curry(MODULE.Init)

	for k, v in next, player.GetAll() do
		
		MODULE:Init(v)
	
	end

	function MODULE:Save(ply, amount)
	
		local dirName = self:Init(ply)
		file.Write(tag_escaped .. "/" .. dirName .. "/karma.txt", amount or self:Get(ply))
		
	end
	PLAYER.SaveKarma = Curry(MODULE.Save)
	
	function MODULE:Load(ply)
	
		self:Init(ply)
		ply:SetNWString(tag, tostring(self:Get(ply)))
		
	end
	PLAYER.LoadKarma = Curry(MODULE.Load)

	function MODULE:Set(ply, amount)

		if not isnumber(amount) or amount < -100 then amount = -100 end
		if amount > 100 then amount = 100 end
		
		amount = math.Round(amount)
		self:Save(ply, amount)
		
		ply:SetNWString(tag, tostring(amount))
		
	end
	PLAYER.SetKarma = Curry(MODULE.Set)

	function MODULE:Add(ply, amount)
		
		local Value = ply:GetKarma()
		
		ply:SetKarma(Value + amount)
		
	end
	PLAYER.AddKarma = Curry(MODULE.Add)
	
	hook.Add("PlayerAuthed", tag .. ".Load", Curry(MODULE.Load))
	hook.Add("PlayerDisconnected", tag .. ".Save", Curry(MODULE.Save))
	
end
