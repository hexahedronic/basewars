local grayTop       = Color(128, 128, 128, 250)
local grayBottom    = Color(96, 96, 96, 250)
 
surface.CreateFont("DrugLab.GUI", {
    font = "Roboto",
    size = 24,
    weight = 800,
})
 
local function RequestCook( ent, drug )
    net.Start( "BaseWars.DrugLab.Menu" )
        net.WriteEntity( ent )
        net.WriteString( drug )
    net.SendToServer()
end
 
local function Menu( ent )
    local Frame = vgui.Create( "DFrame" )
    Frame:SetSize( 900, 600 )
    Frame:Center()
    Frame:SetTitle( "Drug Lab" )
    Frame:MakePopup()
   
    function Frame:Paint(w, h)
 
        draw.RoundedBoxEx(8, 0, 0, w, 24, grayTop, true, true, false, false)
        draw.RoundedBox(0, 0, 24, w, h - 24, grayBottom)
 
    end
   
    local List = vgui.Create( "DPanelList", Frame )
    List:EnableHorizontal(false)
    List:EnableVerticalScrollbar(true)
    List:SetPadding(5)
    List:SetSpacing(5)
    List:Dock(FILL)
   
    for k, v in pairs( BaseWars.Config.Drugs ) do
        if k == "CookTime" then continue end
        local Panel = vgui.Create( "DPanel", List )
        Panel:SetSize( 100, 75 )
       
        local Label = vgui.Create( "DLabel", Panel )
        Label:SetPos( 80, 5 )
        Label:SetFont( "DrugLab.GUI" )
        Label:SetTextColor( Color( 130, 130, 130 ) )
        Label:SetText( k )
        Label:SizeToContents()
       
        local Item = vgui.Create( "SpawnIcon", Panel )
        Item:SetPos( 6, 6 )
        Item:SetSize( 64, 64 )
        Item:SetModel( "models/props_junk/PopCan01a.mdl" )
        Item:SetTooltip( "Drug: " .. k )
       
        function Item:DoClick()
            RequestCook( ent, k )
           
            Frame:Close()
        end
       
        List:AddItem( Panel )
    end
end
 
net.Receive( "BaseWars.DrugLab.Menu", function( len )
    Menu( net.ReadEntity() )   
end )
