MODULE.Name 	= "Notify"
MODULE.Author 	= "Q2F2 & Ghosty"
MODULE.Realm	= 2

local tag = "BaseWars.Notify"

function MODULE:__INIT()
	
	surface.CreateFont(tag, {
		font = "Roboto",
		size = 16,
		weight = 800,
		antialias = true
	})

end

local HUDNote_c = 0
local HUDNote_i = 1
local HUDNotesm = {}

local Alpha = 1000

function MODULE:Add(str, col)

	Alpha = BaseWars.Config.Notifications.OpenTime * 100

	local tab = {}
	
	tab.text 	= str
	tab.col		= col
	tab.col.a 	= Alpha
	
	tab.x		= 20
	tab.y		= 0
	
	surface.SetFont(tag)
	tab.w, tab.h = surface.GetTextSize(str)
	
	HUDNotesm[#HUDNotesm+1] = tab
	
	HUDNote_c = HUDNote_c + 1
	HUDNote_i = HUDNote_i + 1
	
end

local Shadow = Color(0, 0, 0, 150)

function MODULE:DrawMessage(self, k, v, i)

	if Alpha <= 0 then
	
		return
		
	end

	local x = v.x
	local y = v.y
	local w = v.w
	local h = v.h
	
	w = w + 16
	h = h + ((i - 1) * v.h) + (BaseWars.PSAText and 10 or 0)
	y = y + h
	
	surface.SetFont(tag)
	
	surface.SetTextColor(Shadow.r, Shadow.g, Shadow.b, math.min(Alpha, Shadow.a))
	surface.SetTextPos(x + 1, y + 1)
	surface.DrawText(v.text)
	
	surface.SetTextColor(v.col.r, v.col.g, v.col.b, Alpha)
	surface.SetTextPos(x, y)
	surface.DrawText(v.text)
	
end

function MODULE:GetHeight()

	local Lines = BaseWars.Config.Notifications.LinesAmount
	
	surface.SetFont(tag)
	local w, h = surface.GetTextSize("aAbBcCdDeEfFgGhHiIjJkKlLmMoOpP")
	
	return h * Lines
	
end

function MODULE:Paint()

	local w, h = BaseWars.Config.Notifications.Width, self:GetHeight()
	
	local col = BaseWars.Config.Notifications.BackColor

	surface.SetDrawColor(col.r, col.g, col.b, math.min(Alpha, col.a))
	surface.DrawRect(10, (BaseWars.PSAText and 20 or 10), w + 12, h + 12)

	if not HUDNotesm then
	
		return
	
	end
	
	while #HUDNotesm > BaseWars.Config.Notifications.LinesAmount do
	
		table.remove(HUDNotesm, 1)
		
	end
	
	local i = 0
	
	for k, v in next, HUDNotesm do
	
		i = i + 1
		self:DrawMessage(self, k, v, i)
		
	end
	
	if Alpha > 0 then
	
		Alpha = Alpha - 1
		
	end
	
end
hook.Add("HUDPaint", tag .. ".Paint", Curry(MODULE.Paint))
