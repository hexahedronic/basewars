MiniMap = {}

MiniMap.PlyIcon = Material("icon16/user.png")
MiniMap.Radius = 75

local circles = {}
local deg = 0
local sin, cos, rad = math.sin, math.cos, math.rad

function draw.DrawCircle(name, quality, xpos, ypos, size, color)

	circles[name] = {}

	for i = 1, quality do
		deg = rad(i * 360) / quality
		circles[name][i] = {
			x = xpos + cos(deg) * size,
			y = ypos + sin(deg) * size
		}
	end
	
	surface.SetDrawColor(color)
	draw.NoTexture()
	surface.DrawPoly(circles[name])

end

function MiniMap:GetVec(ply)

	local pos = ply:GetPos()
	local x, y = pos.x, pos.y
	
	return Vector(x, y, 0)
	
end

function MiniMap:GetDist(p1, p2)

	local vec1 = MiniMap:GetVec(p1)
	local vec2 = MiniMap:GetVec(p2)
	
	return vec1:Distance(vec2)
	
end

function MiniMap:GetAngle(p1, p2)

	local eyeAngles = p1:EyeAngles()
	local p1Pos = p1:GetPos()
	local p2Pos = p2:GetPos()
	local PosAng = (p1Pos - p2Pos):Angle().y
	
	return math.AngleDifference(eyeAngles.y - 180, PosAng)
	
end

function MiniMap:GetPos(dist, ang)

	local radCalculated = rad(ang + 180)
	local radius = math.Clamp(dist, 0, MiniMap.Radius * 10) * 0.1
	local posx = -sin(radCalculated) * radius
	local posy = cos(radCalculated) * radius
	
	return posx, posy
	
end

function MiniMap:ShoulDraw(me)

	return me:GetNW2Bool("BaseWars_HasRadar", false)

end

function MiniMap:GetRange()

	return 2048
	
end

local grey = Color(50, 50, 50, 155)
function MiniMap:Draw()

	local me = LocalPlayer()
	
	if not self:ShoulDraw(me) then return end
	
	local x, y = ScrW() - 25 - MiniMap.Radius, ScrH() - 25 - MiniMap.Radius
	draw.DrawCircle("minimap_bg", 60, x, y, MiniMap.Radius, grey)
	
	for _, ply in next, ents.FindInSphere(me:GetPos(), self:GetRange()) do
	
		if not BaseWars.Ents:ValidPlayer(ply) or ply == me then continue end
	
		local dist 	= MiniMap:GetDist(me, ply)
		local ang 	= MiniMap:GetAngle(me, ply)
		
		local posx, posy = MiniMap:GetPos(dist, ang)
		
		if ply:InFaction() and ply:InFaction(me:GetFaction()) then
		
			surface.SetDrawColor(100, 255, 100, 255)
		
		elseif me:InRaid() and ply:InRaid() then
		
			surface.SetDrawColor(255, 100, 100, 255)
		
		else
		
			surface.SetDrawColor(255, 255, 255, 255)
			
		end
		
		surface.SetMaterial(MiniMap.PlyIcon)
		surface.DrawTexturedRectRotated(x + posx, y + posy, 16, 16, -math.AngleDifference(me:EyeAngles().y, ply:EyeAngles().y))
		
	end
	
end

hook.Add("HUDPaint", "MiniMap", function() MiniMap:Draw() end)
