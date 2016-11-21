AddCSLuaFile()

if SERVER then

	local hostname = GetConVar("hostname"):GetString() 
	function SetHostName(what)
	
		hostname = what
		game.ConsoleCommand("hostname " .. what .. "\n")
		
	end
	
	function GetHostName()
	
		return hostname
		
	end
	
	timer.Create("HostNameRefresher", 1, 0, function()
	
		SetGlobalString("Hn", hostname)
		
	end)
	
else

	function GetHostName()
	
		return GetGlobalString("Hn")
		
	end
	
end
