--[[

	BaseWars Module Loader
	Coded by Ghosty

]]--

local BW = BaseWars

local colorRed 		= Color(255, 0, 0)
local colorBlue 	= Color(0, 0, 255)
local colorWhite 	= Color(255, 255, 255)

local function Log(...)

	MsgC(SERVER and colorRed or colorBlue, "[BWML] ", colorWhite, ...)
	MsgN("")

end

if not BW then -- Woah, no BaseWars table? This should be loaded AFTER the table's created!

	Log("No BaseWars table??")
	return

end

if SERVER and not BW.UTIL then -- Woah, no UTIL table? This should be loaded AFTER the table's created!

	Log("No BaseWars.UITL table??")
	return

end

local ModuleLoader = {}
local fileFind = file.Find
local next = next

function ModuleLoader:IterateFiles(folder, realm)

	local files = fileFind("basewars_free/gamemode/" .. folder .. "/*", realm or "LUA")

	if #files == 0 then

		files = fileFind(folder .. "/*", realm or "LUA")

	end

	local newFiles = {}

	for _, fileName in next, files do

		newFiles[#newFiles + 1] = folder .. "/" .. fileName

	end

	local i = 0

	local function iter()

		i = i + 1
		return newFiles[i]

	end

	return iter
end

local getFn = string.GetFileFromFilename

local function loadModule()

	BW[MODULE.Name] = table.Copy(MODULE)
	
	if MODULE.__INIT then
	
		BW[MODULE.Name]:__INIT()
		
	end

end

function ModuleLoader:Load()

	local oldTime = SysTime()
	local moduleCount = 0

	for fName in self:IterateFiles("modules") do

		MODULE = {}
		
		function Curry(f)

			local MODULE = MODULE
			local function curriedFunction(...)
				return f(MODULE, ...)
			end

			return curriedFunction

		end
		
		local ok, err = pcall(include, fName)

		if not ok then
			
			local name = MODULE.Name or getFn(fName)
			Log("There was an error loading the module ", colorGreen, "\"", name, "\"", colorWhite, ".",
				"The error is:\n", err)

			continue

		end

		if not MODULE.Name then

			Log("Module with empty name: ", getFn(fName), ", ignoring.")
			continue

		end

		local realm = MODULE.Realm

		if realm == 2 then
				
			if SERVER then
				
				AddCSLuaFile(fName)

			else

				loadModule()

			end
				
		elseif realm == 1 then

			if SERVER then
				
				loadModule()

			end

		elseif not realm or realm == 3 then

			if SERVER then
				
				AddCSLuaFile(fName)

			end

			loadModule()

		end

		moduleCount = moduleCount + 1

	end
	
	MODULE = nil
	Curry = nil

	local newTime = SysTime()
	Log("STATS: Loaded ", tostring(moduleCount), " modules in ", tostring(math.Round(newTime - oldTime, 5)), " seconds.")

end

BW.ModuleLoader = ModuleLoader
