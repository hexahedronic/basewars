MODULE.Name 	= "Money"
MODULE.Author 	= "Q2F2, Ghosty and Tenrys"
MODULE.Credits 	= "Based on sh_money by Tenrys; https://github.com/Tenrys/tenrys-scripts/blob/master/lua/autorun/sh_money.lua"

local tag = "BaseWars.Money"
local tag_escaped = "basewars_money"
local PLAYER = debug.getregistry().Player

local function isPlayer(ply)

	return (IsValid(ply) and ply:IsPlayer())
	
end

function MODULE:GetMoney(ply)

	if SERVER then
	
		local dirName = self:InitMoney(ply)
		local money = tonumber(file.Read(tag_escaped .. "/" .. dirName .. "/money.txt", "DATA"))
		return money
		
	elseif CLIENT then
	
		return tonumber(ply:GetNWString(tag)) or 0
		
	end
	
end
PLAYER.GetMoney = Curry(MODULE.GetMoney)

if SERVER then

	function MODULE:InitMoney(ply)
	
		local dirName = isPlayer(ply) and ply:SteamID64() or (isstring(ply) and ply or nil)
		
		if not file.IsDir(tag_escaped .. "/" .. dirName, "DATA") then file.CreateDir(tag_escaped .. "/" .. dirName) end
		if not file.Exists(tag_escaped .. "/" .. dirName .. "/money.txt", "DATA") then file.Write(tag_escaped .. "/" .. dirName .. "/money.txt", tostring(BaseWars.Config.StartMoney)) end
		file.Write(tag_escaped .. "/" .. dirName .. "/player.txt", ply:Name())
			
		return dirName
		
	end
	PLAYER.InitMoney = Curry(MODULE.InitMoney)

	for k, v in next,player.GetAll() do
		
		MODULE:InitMoney(v)
	
	end

	function MODULE:SaveMoney(ply, amount)
	
		local dirName = self:InitMoney(ply)
		file.Write(tag_escaped .. "/" .. dirName .. "/money.txt", amount or self:GetMoney(ply))
		
	end
	PLAYER.SaveMoney = Curry(MODULE.SaveMoney)
	
	function MODULE:LoadMoney(ply)
	
		self:InitMoney(ply)
		ply:SetNWString(tag, tostring(self:GetMoney(ply)))
		
	end
	PLAYER.LoadMoney = Curry(MODULE.LoadMoney)

	function MODULE:SetMoney(ply, amount)
	
		if not isnumber(amount) or amount < 0 then amount = 0 end
		if amount > 2^63 then amount = 2^63 end
		
		if amount ~= amount then amount = 0 end
		
		amount = math.Round(amount)
		self:SaveMoney(ply, amount)
		
		ply:SetNWString(tag, tostring(amount))
		
	end
	PLAYER.SetMoney = Curry(MODULE.SetMoney)

	function MODULE:GiveMoney(ply, amount)
	
		self:SetMoney(ply, self:GetMoney(ply) + amount)
		
	end
	PLAYER.GiveMoney = Curry(MODULE.GiveMoney)
	
	function MODULE:TakeMoney(ply, amount)
	
		self:SetMoney(ply, self:GetMoney(ply) - amount)
		
	end
	PLAYER.TakeMoney = Curry(MODULE.TakeMoney)

	function MODULE:TransferMoney(ply1, amount, ply2)
	
		self:TakeMoney(ply1, amount)
		self:GiveMoney(ply2, amount)
		
	end
	PLAYER.TransferMoney = Curry(MODULE.TransferMoney)

	hook.Add("PlayerAuthed", tag .. ".Load", Curry(MODULE.LoadMoney))
	hook.Add("PlayerDisconnected", tag .. ".Save", Curry(MODULE.SaveMoney))
	
end
