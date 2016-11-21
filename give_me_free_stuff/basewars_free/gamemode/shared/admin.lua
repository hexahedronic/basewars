bwa = {}

---------------------------------------------------------------
-- UTIL Funcs -------------------------------------------------
---------------------------------------------------------------

function bwa.Log(...)



end

function bwa.Msg(ply, ...)



end

function bwa.Error(ply, msg)

	if msg then
	
		ply:SendLua(string.format(
			"local s = '%s' notification.AddLegacy(s, NOTIFY_ERROR, 5) MsgN(s)",
			"bwa: " .. msg
		))
	
	end
	
	ply:EmitSound("buttons/button8.wav")
	
end

---------------------------------------------------------------
-- Commands ---------------------------------------------------
---------------------------------------------------------------


bwa.Reasons = {

	"Cheating",
	"Mingebag",
	"Too young",
	"Multi-Basing",
	"Prop-Blocking People",
	"Exploiting",
	"Multi-Faction Base",
	
}

function bwa.Kick(ply, caller, res)

	local Ret, Msg = hook.Run("bwaKick", ply, caller, res)
	
	if Ret == false then
	
		if Msg then
		
			bwa.Error(caller, Msg)
			
		end
		
	return false end
	
	ply:Kick("bwa: Kicked by " .. caller:Nick() .. " for '" .. res .. "'.")
		

end

properties.Add("bwa_copymodel", {

	MenuLabel = "Copy Model",
	MenuIcon = "icon16/page_copy.png",
	Order =	-100,
	
	Filter = function(self, ent, ply)
	
		if not IsValid(ent) then return false end
		
		return true 
		
	end,
	
	Action = function(self, ent)
		
		local Model = ent:GetModel()
		SetClipboardText(Model)
		
	end,
		
})

properties.Add("bwa_copymaterial", {

	MenuLabel = "Copy Material",
	MenuIcon = "icon16/page_copy.png",
	Order =	-99,
	
	Filter = function(self, ent, ply)
	
		if not IsValid(ent) or not (ent:GetMaterial() and #ent:GetMaterial() > 0)then return false end
		
		return true 
		
	end,
	
	Action = function(self, ent)
		
		local Mat = ent:GetMaterial()
		SetClipboardText(Mat)
		
	end,
		
})

properties.Add("bwa_kick", {

	MenuLabel = "Kick",
	MenuIcon = "icon16/error_delete.png",
	Order =	math.huge,
	
	Filter = function(self, ent, ply)
	
		if not IsValid(ent) or not ply:IsAdmin() or not ent:IsPlayer() then return false end
		
		return true 
		
	end,
	
	Action = function(self, ent)
	
		self:MsgStart()
			net.WriteEntity(ent)
			net.WriteString("No Reason")
		self:MsgEnd()
		
	end,
	
	KickOption = function(self, ent, res)
	
		self:MsgStart()
			net.WriteEntity(ent)
			net.WriteString(res)
		self:MsgEnd()
		
	end,
	
	Receive = function(self, length, ply)
	
		local ent = net.ReadEntity()
		local res = net.ReadString()

		if not IsValid(ply) or not IsValid(ent) or not self:Filter(ent, ply) then return false end
		
		bwa.Kick(ent, ply, res)
		
	end,
	
	MenuOpen = function(self, option, ent, tr)

		if IsValid(ent.AttachedEntity) then ent = ent.AttachedEntity end

		local options = bwa.Reasons
		local submenu = option:AddSubMenu()

		for k, v in next, options do

			submenu:AddOption(v, function() self:KickOption(ent, v) end)

		end
		
		submenu:AddOption("Custom...", function()
			
			Derma_StringRequest("Custom Kick Reason", "Kick " .. ent:Nick() .. " for...", "", function(t) self:KickOption(ent, t) end)
			
		end)

	end,
		
})

properties.Add("bwa_refund", {

	MenuLabel = "Refund All",
	MenuIcon = "icon16/money_add.png",
	Order =	2^32,
	
	Filter = function(self, ent, ply)
	
		if not IsValid(ent) or not ply:IsAdmin() or not ent:IsPlayer() then return false end
		
		return true 
		
	end,
	
	Action = function(self, ent)
	
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
		
	end,
	
	Receive = function(self, length, ply)
	
		local ent = net.ReadEntity()

		if not IsValid(ply) or not IsValid(ent) or not self:Filter(ent, ply) then return false end
		
		BaseWars.UTIL.RefundAll(ent)
		
	end,
		
})

properties.Add("bwa_invite", {

	MenuLabel = "Invite to Faction",
	MenuIcon = "icon16/group_add.png",
	Order =	-1,
	
	Filter = function(self, ent, ply)
	
		if not IsValid(ent) or not ent:IsPlayer() then return false end
		
		return true 
		
	end,
	
	Action = function(self, ent)
	
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
		
	end,
	
	Receive = function(self, length, ply)
	
		local ent = net.ReadEntity()

		if not IsValid(ply) or not IsValid(ent) or not self:Filter(ent, ply) then return false end
		
		bwa.Error(ply, "Not yet implemented :/")
		
	end,
		
})
