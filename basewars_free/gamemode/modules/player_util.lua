MODULE.Name 	= "Util_Player"
MODULE.Author 	= "Q2F2 & Ghosty"

local tag = "BaseWars.Util_Player"
local PLAYER = debug.getregistry().Player

if SERVER then

	util.AddNetworkString(tag)
	
end
	
function MODULE:HandleNetMessage(len, ply)

	local Mode = net.ReadUInt(1)
	
	if CLIENT then
	
		local ply = LocalPlayer()
	
		if Mode == 0 then
		
			local text = net.ReadString()
			local col = net.ReadColor()
		
			self:Notification(ply, text, col)
		
		end
	
	end
	
end
net.Receive(tag, Curry(MODULE.HandleNetMessage))

function MODULE:Notification(ply, text, col)

	if SERVER then
		
		net.Start(tag)
			net.WriteUInt(0, 1)
			net.WriteString(text)
			net.WriteColor(col)
		if ply then net.Send(ply) else net.Broadcast() end
		
		BaseWars.UTIL.Log(ply, " -> ", text)
		
		return
		
	end
	
	MsgC(col, text, "\n")
	BaseWars.Notify:Add(text, col)
	
end
local notification = Curry(MODULE.Notification)
Notify = notification
PLAYER.Notify = notification

function MODULE:NotificationAll(text, col)

	self:Notification(nil, text, col)

end
NotifyAll = Curry(MODULE.NotificationAll)

function MODULE:Spawn(ply) 

	local col = ply:GetInfo("cl_playercolor")
	ply:SetPlayerColor(Vector(col))

	local col = Vector(ply:GetInfo("cl_weaponcolor"))
	
	if col:Length() == 0 then
	
		col = Vector(0.001, 0.001, 0.001)
		
	end
	
	ply:SetWeaponColor(col)

end
hook.Add("PlayerSpawn", tag .. ".Spawn", Curry(MODULE.Spawn))

function MODULE:EnableFlashlight(ply)

	ply:AllowFlashlight(true)
	
end

hook.Add("PlayerSpawn", tag .. ".EnableFlashlight", Curry(MODULE.EnableFlashlight))

function MODULE:PlayerSetHandsModel(ply, ent)

	local PlayerModel 	= player_manager.TranslateToPlayerModelName(ply:GetModel())
	local HandsInfo 	= player_manager.TranslatePlayerHands(PlayerModel)
	
	if HandsInfo then
	
		ent:SetModel(HandsInfo.model)
		ent:SetSkin(HandsInfo.skin)
		ent:SetBodyGroups(HandsInfo.body)
		
	end

end
hook.Add("PlayerSetHandsModel", tag .. ".PlayerSetHandsModel", Curry(MODULE.PlayerSetHandsModel))

function MODULE:Stuck(ply, pos)

	local t = {}

	t.start 	= pos or ply:GetPos()
	t.endpos 	= t.start
	t.filter 	= ply
	t.mask 		= MASK_PLAYERSOLID
	t.mins 		= ply:OBBMins()
	t.maxs 		= ply:OBBMaxs()
	
	t = util.TraceHull(t)
	
	local ent = t.Entity
	
	return t.StartSolid or (ent and (ent:IsWorld() or IsValid(ent)))
	
end
PLAYER.Stuck = Curry(MODULE.Stuck)

local function FindPassableSpace(ply, direction, step)

	local OldPos = ply:GetPos()
	local Origin = ply:GetPos()
	
	for i = 1, 11 do
		Origin = Origin + (step * direction)
		
		if not ply:Stuck(Origin) then return true, Origin end
		
	end
	
	return false, OldPos
	
end

function MODULE:UnStuck(ply, ang, scale)

	local NewPos = ply:GetPos()
	local OldPos = NewPos
	
	if not ply:Stuck() then return end
	
	local Ang = ang or ply:GetAngles()
	
	local Forward 	= Ang:Forward()
	local Right 	= Ang:Right()
	local Up 		= Ang:Up()
	
	local SearchScale = scale or 3
	local Found
	
	Found, NewPos = FindPassableSpace(ply, Forward, -SearchScale)
	
	if not Found then
	
		Found, NewPos = FindPassableSpace(ply, Right, SearchScale)
		
		if not Found then
		
			Found, NewPos = FindPassableSpace(ply, Right, -SearchScale)
			
			if not Found then
			
				Found, NewPos = FindPassableSpace(ply, Up, -SearchScale)
				
				if not Found then
				
					Found, NewPos = FindPassableSpace(ply, Up, SearchScale)
					
					if not Found then
					
						Found, NewPos = FindPassableSpace(ply, Forward, SearchScale)
						
						if not Found then
						
							return false	
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
	if OldPos == NewPos then
	
		return false
		
	else
	
		
		local HitString = math.floor(NewPos.x) .. "," .. math.floor(NewPos.y) .. "," .. math.floor(NewPos.z)
		BaseWars.UTIL.Log("USTK EVENT: ", ply, " -> [", HitString, "]")
	
		ply:SetPos(NewPos)
		return true
		
	end
		
end
PLAYER.UnStuck = Curry(MODULE.UnStuck)