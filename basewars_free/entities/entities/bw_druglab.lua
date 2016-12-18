AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
 
ENT.PrintName = "Drug Lab"
ENT.Model = "models/props_lab/crematorcase.mdl"
 
ENT.PowerRequired = 10
ENT.PowerCapacity = 5000
 
ENT.Drain = 15
 
ENT.Status = "Press e to start cooking!"
 
if SERVER then
 
util.AddNetworkString( "BaseWars.DrugLab.Menu" )
ENT.UsedTime = CurTime()
ENT.Cooking = false
ENT.CookTime = BaseWars.Config.Drugs.CookTime
ENT.CookStart = 0
ENT.Cook = ""
 
net.Receive("BaseWars.DrugLab.Menu", function(len, cl)
    local Ent = net.ReadEntity()
    local Owner = BaseWars.Ents:ValidOwner(Ent)
	
    if not BaseWars.Ents:Valid( Ent ) then return end
    if not BaseWars.Ents:ValidPlayer(Owner) or not BaseWars.Ents:ValidPlayer(cl) then return end
    if Owner ~= cl then return end
	
    if Ent:GetClass() ~= "bw_druglab" then return end
    if not Ent.Status == "Press e to start cooking!" then return end
	
    Ent:StartCooking(net.ReadString())
	
end)
 
function ENT:StartCooking( drug )
    if not drug or drug == "" then return end
    self.Cooking = true
    self.CookStart = CurTime()
    self.Cook = drug
end
 
function ENT:SpawnDrug( drug )
    local Ent = ents.Create("bw_drink_drug")
        Ent:SetDrugEffect(drug)
        Ent.Random = false
        Ent:SetPos(self:GetPos() + self:GetUp() * 16 )
        Ent:SetAngles(self:GetAngles())
    Ent:Spawn()
    Ent:Activate()
end
 
function ENT:ThinkFunc()
    self:SetNWString( "Status", self.Status )
   
    if CurTime() < self.CookStart + self.CookTime then
        local timeleft = (self.CookStart + self.CookTime) - CurTime()
        self.Status = "Cooking " .. self.Cook .. " (" .. BaseWars.UTIL.TimeParse( timeleft ) .. ")"
		
		self:DrainPower(self.Drain)
    else
        if self.Cooking then
            self:SpawnDrug( self.Cook )
            self.Cooking = false
            self.CookStart = 0
            self.Status = "Press e to start cooking!"
            self.Cook = ""
        end
    end
end
 
function ENT:UseFunc(ply)
	
	local Owner = BaseWars.Ents:ValidOwner(self)
    if not BaseWars.Ents:Valid( self ) then return end
    if not BaseWars.Ents:ValidPlayer(Owner) or not BaseWars.Ents:ValidPlayer(ply) then return end
    if Owner ~= ply then return end
 
    if self.UsedTime + 1 > self.UsedTime then
       
         net.Start("BaseWars.DrugLab.Menu")
			net.WriteEntity(self)
		net.Send(ply)
	
        self.UsedTime = CurTime()
		
	end
 
end

else
 
local textx, texty = 0, 0
ENT.FontName = "DrugLab"
 
function ENT:Initialize()
    surface.CreateFont(self.FontName, {
        font = "Roboto",
        size = 48,
        weight = 800,
    })
   
    surface.SetFont( self.FontName )
    textx, texty = surface.GetTextSize( self.PrintName )
end
 
function ENT:Draw()
    //self.BaseClass:Draw()
    self:DrawModel()
   
    self.Status = self:GetNWString( "Status", self.Status or "ERROR" )
    surface.SetFont( self.FontName )
    local textx2, texty2 = surface.GetTextSize( self.Status )
   
    local angles = self:GetAngles()
    angles:RotateAroundAxis( self:GetUp(), 180 )
    angles:RotateAroundAxis( self:GetForward(), -90 )
   
    cam.Start3D2D( self:GetPos() + self:GetUp() * 45, angles, 0.1 )
        surface.SetDrawColor( 0, 0, 0 )
        surface.DrawRect( -(textx / 2) - 5, -(texty / 2) - 5, textx + 10, texty + 10 )
       
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetFont( self.FontName )
        surface.SetTextPos( -(textx / 2), -(texty / 2) )
        surface.DrawText( self.PrintName )
       
        surface.SetDrawColor( 0, 0, 0 )
        surface.DrawRect( -(textx2 / 2) - 5, 65 + -(texty2 / 2) - 5, textx2 + 10, texty2 + 10 )
       
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetFont( self.FontName )
        surface.SetTextPos( -(textx2 / 2), 65 + -(texty2 / 2) )
        surface.DrawText( self.Status )
    cam.End3D2D()
end
 
end
