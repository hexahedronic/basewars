MODULE.Name 	= "Prop Remover"
MODULE.Author 	= "BROLY" --Thanks to Q2F2 for the tip on what function to hook!
// Finds all physics props on the map and removes them when all the entities are frist initialized (AKA: When the map first loads).

local function RemoveProps()
	BaseWars.UTIL.Log( "Prop Remover: Removing Map Props")
		for k, v in pairs( ents.FindByClass( "prop_physics*" ) ) do		
			v:Remove()
		end
	BaseWars.UTIL.Log( "Prop Remover: All Map Props Removed!" )
end

hook.Add( "PostCleanupMap", "CleanEverythingCheck", function()
	if BaseWars.Config.CleanProps then
	RemoveProps()
	end
end )

hook.Add( "InitPostEntity", "RemoveProps", function()
	if BaseWars.Config.CleanProps then
	RemoveProps()
	end
end )
