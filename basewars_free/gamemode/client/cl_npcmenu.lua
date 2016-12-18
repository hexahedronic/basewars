local me = LocalPlayer()
local tag = "BaseWars.NPCs.Menu"

local grayTop 		= Color(128, 128, 128, 250)
local grayBottom 	= Color(96, 96, 96, 250)

local nodePanelBg	= Color(192, 192, 192, 250)
local shadowColor 	= Color(0, 0, 0, 200)

local bigFont = tag .. ".BigFont"
local medFont = tag .. ".MedFont"
local smallFont = tag .. ".SmallFont"

surface.CreateFont(bigFont, {

	font = "Roboto",
	size = 32,

})

surface.CreateFont(medFont, {

	font = "Roboto",
	size = 18,

})

surface.CreateFont(smallFont, {

	font = "Roboto",
	size = 16,

})

local white = Color(255, 255, 255)
local gray = Color(192, 192, 192)
local black = Color(0, 0, 0)

local function PrepMenu(ent)

	local Name = ent.PrintName

	local mainFrame = vgui.Create("DFrame")

	mainFrame:SetSize(900, 600)
	mainFrame:Center()
	mainFrame:SetTitle(Name)
	mainFrame:SetIcon("icon16/application.png")
	mainFrame:MakePopup()

	function mainFrame:Paint(w, h)

		draw.RoundedBoxEx(8, 0, 0, w, 24, grayTop, true, true, false, false)
		draw.RoundedBox(0, 0, 24, w, h - 24, grayBottom)

	end
	
	local tabPanel = mainFrame:Add("DPropertySheet")

	tabPanel:Dock(FILL)
	tabPanel:SetWide(200)

	function tabPanel:MakeTab(name, icon)

		local dpanel = vgui.Create("DPanel")
		self:AddSheet(name, dpanel, icon)

		return dpanel

	end
	
	local function PopulateFromTable(panel, tbl)
	
		local PanelList = vgui.Create("DPanelList", panel)
		
		PanelList:EnableHorizontal(false)
		PanelList:EnableVerticalScrollbar(true)
		
		PanelList:SetPadding(5)
		PanelList:SetSpacing(5)
		
		PanelList:Dock(FILL)
		
		for k, v in next, tbl do
		
			local Cat = vgui.Create("DCollapsibleCategory", PanelList) 
			Cat:SetLabel(k)
			
			Cat:SetExpanded(false)
			
			Cat:SetHeight(100)
			
			local List = vgui.Create("DPanelList", Cat)
			
			List:SetPadding(5)
			List:SetDrawBackground(true)
			
			Cat:SetContents(List)
			
			for i, t in next, v do
			
				local Label = vgui.Create("DLabel", List)
				
				Label:SetText(t)
				
				Label:SetDark(true)
				Label:SetWrap(true)
				
				List:AddItem(Label)
				
			end
			
			List:Dock(FILL)
			
			local Tall = #v * 22
			
			-- Garry is a massive cockhead
			List.__PerformLayout = List.PerformLayout
			List.PerformLayout = function(pan)
			
				pan:SetSize(Cat:GetSize(), Tall)
				
				pan:__PerformLayout()
				
			end
			
			PanelList:AddItem(Cat)
			
		end
		
		PanelList:InvalidateLayout()
		
	end

	local HelpTab = tabPanel:MakeTab("Help", "icon16/help.png")
	local DrugsTab = tabPanel:MakeTab("Drugs", "icon16/bin_closed.png")
	local CommsTab = tabPanel:MakeTab("Commands", "icon16/ruby_gear.png")
	
	PopulateFromTable(HelpTab, BaseWars.Config.Help)
	PopulateFromTable(DrugsTab, BaseWars.Config.DrugHelp)
	PopulateFromTable(CommsTab, BaseWars.Config.CommandsHelp)
	return mainFrame

end

local pnl
local function MakeNotExist(...)

	if pnl and IsValid(pnl) then return end

	pnl = PrepMenu(...)
	
end

 local function ReceiveNet(len)
 
	local Ent = net.ReadEntity()
	
	MakeNotExist(Ent)
	
end
net.Receive(tag, ReceiveNet)
