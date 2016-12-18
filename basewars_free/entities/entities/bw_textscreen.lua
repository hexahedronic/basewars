AddCSLuaFile()

ENT.Base 	= "base_gmodentity"
ENT.Type 	= "anim"

if SERVER then

	function ENT:Initialize()

		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

		self:PhysWake()

	end

	function ENT:NetworkLines(lines)

		self:SetNWString("textscreen_lines", table.concat(lines,"\n"))

	end

else

	local fts = {}

	local function GetFont(s)

		if fts[s] then
			
			return fts[s]

		end

		local ft = "textscreen" .. s

		surface.CreateFont(ft, {

			font = "Roboto",
			size = s,
			antialias = false,
			outline = true,

		})

		fts[s] = ft

		return ft

	end

	function ENT:Draw3D2D(pos, ang, scale)

		local l = self.Lines

		local col = color_white
		local font = GetFont(24)

		local y = 0

		for _, line in next, l do


			line = line:gsub("\\f","f;")
			line = line:gsub("\\c","c;")
			
			if line:match("c:%d- %d- %d- %d+;?") then
				
				local r,g,b,a = line:match("c:(%d-) (%d-) (%d-) (%d+);?")

				col = Color(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
				line = line:gsub("c:%d- %d- %d- %d+;?", "")

			elseif line:match("c:%d- %d- %d+;?") then
				
				local r,g,b,a = line:match("c:(%d-) (%d-) (%d+);?")
				a = 255

				col = Color(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
				line = line:gsub("c:%d- %d- %d+;?", "")

			end

			if line:match("f:%d+;?") then
				
				local siz = line:match("f:(%d+)")

				font = GetFont(tonumber(siz))

				line = line:gsub("f:(%d+);?", "")

			end	

			line = line:gsub("f;","\\f")
			line = line:gsub("c;","\\c")

			surface.SetFont(font)

			local _, th = surface.GetTextSize(line)

			draw.DrawText(line, font, 0, y, col, TEXT_ALIGN_CENTER)

			y = y + th

		end

	end

	function ENT:Calc3D2DParams(pos, ang)

		ang:RotateAroundAxis(ang:Right(), 90)

		pos = pos + ang:Up() * -5.5

		return pos, ang, 0.5

	end

	function ENT:Draw()

		self:DestroyShadow()

		if not self.Lines then return end

		local pos, ang, scale = self:Calc3D2DParams(self:GetPos(), self:GetAngles())

		cam.Start3D2D(pos, ang, scale)

			pcall(self.Draw3D2D, self, pos, ang, scale)

		cam.End3D2D()

	end

	function ENT:Think()

		local tbl = {}

		local lines = self:GetNWString("textscreen_lines", "none")

		if lines == "none" then return end

		if self.rawlines == lines then return end

		self.Lines = lines:Split("\n")
		self.rawlines = lines

	end

end
