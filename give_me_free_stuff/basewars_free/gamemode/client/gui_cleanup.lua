local blacklist = {
	"DMenuBar",
	"DMenu",
	"SpawnMenu",
	"ContextMenu",
	"ControlPanel",
	"CGMODMouseInput",
	"Panel",
}

local lightblacklist = {
	"scoreboard",
	"menu",
	"f1",
	"f2",
	"f3",
	"f4",
	"playx",
	"gcompute",
}

local function VGUICleanup()
	local sum = 0
	for _,pnl in next,vgui.GetWorldPanel():GetChildren() do
		if not IsValid(pnl) then continue end
		local name = pnl:GetName()
		local class = pnl:GetClassName()
		local hit_blacklist = false
		if blacklist[class] then continue end
		if blacklist[name] then continue end
		for _,class in next,lightblacklist do
			if name:lower():match(class:lower()) then
				hit_blacklist = true
				continue
			end
		end
		if hit_blacklist then continue end
		Msg("[vgui] ") print("Removed " .. tostring(pnl))
		pnl:Remove()
		sum = sum + 1
	end
	Msg("[vgui] ") print("Total panels removed: " .. sum)
end

concommand.Add("vgui_cleanup", VGUICleanup)
