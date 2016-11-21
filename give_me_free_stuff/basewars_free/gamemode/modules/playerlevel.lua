MODULE.Name 	= "PlayerLevel"
MODULE.Author 	= "Trixter"

local tag = "BaseWars.PlayerLevel"
local tag_escaped = "basewars_playerlevel"
local PLAYER = debug.getregistry().Player

local function isPlayer(ply)

	return (IsValid(ply) and ply:IsPlayer())
	
end

function MODULE:GetLevel(ply)

	if SERVER then
	
		local dirName = self:Init(ply)
		local level = ply.level or tonumber(file.Read(tag_escaped .. "/" .. dirName .. "/level.txt", "DATA"))
		return tonumber(level)
		
	elseif CLIENT then
	
		return tonumber(ply:GetNWString(tag .. ".Level")) or 0
		
	end
	
end
PLAYER.GetLevel = Curry(MODULE.GetLevel)

function MODULE:GetXP(ply)
	
	if SERVER then
	
		local dirName = self:Init(ply)
		local xp = ply.xp or tonumber(file.Read(tag_escaped .. "/" .. dirName .. "/xp.txt", "DATA"))
		return tonumber(xp)
		
	elseif CLIENT then
	
		return tonumber(ply:GetNWString(tag .. ".XP")) or 0
		
	end
	
end
PLAYER.GetXP = Curry(MODULE.GetXP)

function MODULE:GetXPNextLevel(ply)
	local n = ply:GetLevel()
	return (n + 1) * 250
end
PLAYER.GetXPNextLevel = Curry(MODULE.GetXPNextLevel)

function MODULE:HasLevel(ply, level)
	local plylevel = ply:GetLevel()
	return (plylevel >= level)
end
PLAYER.HasLevel = Curry(MODULE.HasLevel)

if SERVER then

	function MODULE:Init(ply)
	
		local dirName = isPlayer(ply) and ply:SteamID64() or (isstring(ply) and ply or nil)
		
		if not file.IsDir(tag_escaped .. "/" .. dirName, "DATA") then file.CreateDir(tag_escaped .. "/" .. dirName) end
		if not file.Exists(tag_escaped .. "/" .. dirName .. "/level.txt", "DATA") then file.Write(tag_escaped .. "/" .. dirName .. "/level.txt", 1) end
		if not file.Exists(tag_escaped .. "/" .. dirName .. "/xp.txt", "DATA") then file.Write(tag_escaped .. "/" .. dirName .. "/xp.txt", 0) end
		
		return dirName
		
	end
	PLAYER.InitLevel = Curry(MODULE.Init)

	for k, v in next, player.GetAll() do
		
		MODULE:Init(v)
	
	end

	function MODULE:Save(ply)
	
		local dirName = self:Init(ply)
		file.Write(tag_escaped .. "/" .. dirName .. "/level.txt", self:GetLevel(ply))
		file.Write(tag_escaped .. "/" .. dirName .. "/xp.txt", self:GetXP(ply))
		
	end
	PLAYER.SaveLevels = Curry(MODULE.Save)
	
	function MODULE:Load(ply)
	
		self:Init(ply)
		local lvl = tostring(self:GetLevel(ply))
		local xp = tostring(self:GetXP(ply))
		ply:SetNWString(tag .. ".Level", lvl)
		ply:SetNWString(tag .. ".XP", xp)
		ply.level = lvl
		ply.xp = xp
		
	end
	PLAYER.LoadLevels = Curry(MODULE.Load)

	function MODULE:CheckLevels(ply)

		local neededxp = ply:GetXPNextLevel()
		if ply:GetXP() >= neededxp then

			if ply:GetLevel() == 5000 then
				ply:SetLevel( 5000 )
				ply:SetXP( 0 )
				return
			end
		
			ply:AddLevel(1)
			ply:SetXP( ply:GetXP() - neededxp)

		end

	end
	
	function MODULE:Set(ply, amount)

		if not isnumber(amount) or amount < 0 then amount = 0 end
		if amount > 5000 then amount = 5000 end
		
		amount = math.Round(amount)
		
		ply.level = amount
		self:Save(ply)
		
		ply:SetNWString(tag .. ".Level", tostring(amount))
		
	end
	PLAYER.SetLevel = Curry(MODULE.Set)

	function MODULE:AddLevel(ply, amount)
		
		local Value = ply:GetLevel()
		
		ply:SetLevel(Value + amount)
		
	end
	PLAYER.AddLevel = Curry(MODULE.AddLevel)
	
	function MODULE:SetXP(ply, amount)

		if not isnumber(amount) or amount < 0 then amount = 0 end
		
		amount = math.Round(amount)
		
		ply.xp = amount
		self:Save(ply)
		
		ply:SetNWString(tag .. ".XP", tostring(amount))
		
		self:CheckLevels( ply )
		
	end
	PLAYER.SetXP = Curry(MODULE.SetXP)

	function MODULE:AddXP(ply, amount)
		
		local Value = ply:GetXP()
		
		ply:SetXP(Value + amount)
		
	end
	PLAYER.AddXP = Curry(MODULE.AddXP)
	
	hook.Add("PlayerAuthed", tag .. ".Load", Curry(MODULE.Load))
	hook.Add("PlayerDisconnected", tag .. ".Save", Curry(MODULE.Save))
	
end