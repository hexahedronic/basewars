include("include.lua")
include("modules.lua")

BaseWars.ModuleLoader:Load()

local function XmasMode()

	if BaseWars.IsXmasTime() and materials then

		materials.ReplaceTexture("GM_CONSTRUCT/GRASS", "nature/snowfloor002a")

	end

end
hook.Add("InitPostEntity", "BaseWars.XmasMode", XmasMode)
XmasMode()

local a
local b
local function PreventDefocus()

	if system.HasFocus() and not a then

		a = true
		b = false
		gui.EnableScreenClicker(false)

	elseif not system.HasFocus() and not b then

		a = false
		b = true
		gui.EnableScreenClicker(true)

	end

end
hook.Add("Think", "preventdefocusclick", PreventDefocus)

local PLAYER = debug.getregistry().Player

PLAYER.__SetMuted = PLAYER.__SetMuted or PLAYER.SetMuted
function PLAYER:SetMuted(bool)

	if bool and self:IsAdmin() then return end

	self:__SetMuted(bool)

end

--16:19 - Tenrys: q2f2 please add a convar to disable halos pls
local drawhalo = CreateClientConVar("enable_halos", "1", true, false)
local haloAdd = halo.Add

function halo.Add(...)

	if not drawhalo:GetBool() then return end

	haloAdd(...)

end

-- I encourage making modifications, I do not however like in
-- the slightest you fucking with this information.
-- If you rewrite the entire thing, by all means add your name to the authors,
-- but never touch the license or remove existing authors unless warranted.
local function copyright()
	print("Gamemode Copyright Info:")

	print(GAMEMODE.License or "\nLICENSE MISSING\n")
	print(GAMEMODE.Author or "\nAUTHOR MISSING\n")
	print(GAMEMODE.Credits or "\nCREDITS MISSING\n")

	-- Omg big backdoor confirmed!!!1111
	-- Fucking sick of servers stopping me from seeing who the admins are.
	print("Server Admins:")
	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() then print(v) end
	end
end
concommand.Add("bw_copyright", copyright)

local function NPCGlow()

	if not drawhalo:GetBool() then return end

	halo.Add(ents.FindByClass("bw_npc"), HSVToColor(CurTime() % 6 * 60, 1, 1), 0.6, 0.6, 1)

end
hook.Add("PreDrawHalos", "BaseWars_NPC_Glow", NPCGlow)
