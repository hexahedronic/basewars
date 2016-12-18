BASEWARS_CHOSEN_LANGUAGE = "ENGLISH"

BaseWars.Config = {
	Forums 		= "https://scriptfodder.com/scripts/view/3309",
	SteamGroup 	= "http://steamcommunity.com/groups/hexahedronic",

	Ents = {
		Electronics = {
			Explode		= true,
			WaterProof	= false,
		},
		SpawnPoint = {
			Offset 		= Vector(0, 0, 16),
		},
	},

	Drugs = {
		DoubleJump = {
			JumpHeight 	= Vector(0, 0, 320),
			Duration	= 120,
		},
		Steroid = {
			Walk 		= 330,
			Run 		= 580,
			Duration	= 120,
		},
		Regen = {
			Duration 	= 30,
		},
		Adrenaline = {
			Mult		= 1.5,
			Duration	= 120,
		},
		PainKiller = {
			Mult 		= .675,
			Duration	= 80,
		},
		Rage = {
			Mult 		= 1.675,
			Duration	= 120,
		},
		Shield = {

		},
		Antidote = {

		},
		CookTime	= 60 * 2,
	},

	Notifications = {
		LinesAmount = 11,
		Width		= 582,
		BackColor	= Color(30, 30, 30, 140),
		OpenTime	= 10,
	},

	Raid = {
		Time 			= 60 * 5,
		CoolDownTime	= 60 * 15,
		NeededPrinters	= 1,
	},

	AFK  = {
		Time 	= 30,
	},

	HUD = {
		EntFont = "TargetID",
		EntFont2 = "BudgetLabel",
		EntW	= 175,
		EntH	= 25,
	},

	Rules = {
		IsHTML 	= false,
		HTML	= "http://hexahedron.pw/free_rules.html",
	},

	Adverts = {
		Time = 120,
	},

	SpawnWeps = {
		"weapon_physcannon",
		"hands",
	},

	WeaponDropBlacklist = {
		["hands"] = true,
		["weapon_physcannon"] = true,
		["weapon_physgun"] = true,
		["gmod_tool"] = true,
		["gmod_camera"] = true,
	},

	PhysgunBlockClasses = {
		["bw_spawnpoint"] = true,
	},

	BlockedTools = {
		["dynamite"] = true,
		["duplicator"] = true,
	},

	ModelBlacklist = {
	},

	NPC = {
		FadeOut = 400,
	},

	AntiRDM = {
		HurtTime 		= 80,
		RDMSecondsAdd 	= 3,
		KarmaSecondPer 	= 4,
		KarmaLoss 		= -2,
		KarmaGlowLevel 	= 65,
	},

	PayDayBase 			= 500,
	PayDayMin			= 50,
	PayDayDivisor		= 1000,
	PayDayRate 			= 60 * 3,
	PayDayRandom		= 50,

	StartMoney 			= 5000,

	CustomChat			= true,
	ExtraStuff			= true,
	CleanProps			= false, -- Finds all physics props on the map and removes them when all the entities are frist initialized (AKA: When the map first loads).

	AllowFriendlyFire	= false,

	DefaultWalk			= 180,
	DefaultRun			= 300,

	DefaultLimit		= 4,
	SpawnOffset			= Vector(0, 0, 40),

	UniversalPropConstant = 1,
	DestroyReturn 		= 0.6,

	RestrictProps 		= false,

	DispenserTime		= 2,

	LevelSettings = {

		BuyWeapons = 2,

	},

}

BaseWars.NPCTable = {
}

BaseWars.NPCTable[game.GetMap()] = {{Pos = Vector(0, 0, 0), Ang = Angle(0, 0, 0)}} -- Auto spawn for every map

local NiceGreen = Color(100, 250, 125)
local NiceBlue = Color(100, 125, 250)
local Grey = Color(200, 200, 200)

BaseWars.AdvertTbl = {

	{Grey, "Remember to join our ", NiceGreen, "Steam Group", Grey, "! (/steam)"},
	{Grey, "You can find out more on the ", NiceGreen, "Forums", Grey, "! (/forums)"},

}

BaseWars.Config.Help = {

	["Where can I get support for this gamemode?"] = {

		"https://scriptfodder.com/scripts/view/3309",

	},
	
	["Why should I buy this gamemode when it's free AND open-source?"] = {
	
		"The open version is no longer supported, receiving only backports of fixes classed as 'severe'.",
		"",
		"By purchasing the gamemode you get full support from the developers",
		"and a massively improved version of the gamemode,",
		"alongside helping us continue to improve the gamemode",
	
	},
}

BaseWars.Config.DrugHelp = {
}

BaseWars.Config.CommandsHelp = {
}

BaseWars.SpawnList = {}
BaseWars.SpawnList.Models = {}
BaseWars.SpawnList.Models.Entities = {}
BaseWars.SpawnList.Models.Loadout = {}

local WEAPONS = {}

-- https://steamcommunity.com/sharedfiles/filedetails/?id=349050451
-- https://steamcommunity.com/sharedfiles/filedetails/?id=358608166
-- https://steamcommunity.com/sharedfiles/filedetails/?id=359830105

BaseWars.SpawnList = {}
BaseWars.SpawnList.Models = {}
BaseWars.SpawnList.Models.Entities = {}
BaseWars.SpawnList.Models.Loadout = {}

if CustomizableWeaponry then
	BaseWars.SpawnList.Models.Loadout["Weapons - T1"] = {

			["Crowbar"] 				= BaseWars.GSL{Gun = true, Model = "models/weapons/w_crowbar.mdl", Price = 1000, ClassName = "weapon_crowbar"},

			["USP"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_usp.mdl", Price = 5000, ClassName = "cw_g4p_usp40"},
			["M1911"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_usp.mdl", Price = 5000, ClassName = "cw_m1911"},
			["FiveSeven"] 			= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_fiveseven.mdl", Price = 5000, ClassName = "cw_g4p_fiveseven"},

			["Deagle"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_deagle.mdl", Price = 10000, ClassName = "cw_deagle"},
			["MR96"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_deagle.mdl", Price = 11500, ClassName = "cw_mr96"},
			["MP412"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_deagle.mdl", Price = 11500, ClassName = "cw_g4p_mp412_rex"},

			["UMP"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_ump45.mdl", Price = 20000, ClassName = "cw_g4p_ump45"},
			["MP5"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_mp5.mdl", Price = 20000, ClassName = "cw_mp5"},
			["MAC11"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_mac10.mdl", Price = 20000, ClassName = "cw_mac11"},

			["Magpul"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_p90.mdl", Price = 25000, ClassName = "cw_g4p_magpul_masada"},
			["FN FAL"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_galil.mdl", Price = 25000, ClassName = "cw_g4p_fn_fal"},
			["G36"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_galil.mdl", Price = 25000, ClassName = "cw_g36c"},

			["AK74"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_ak47.mdl", Price = 30000, ClassName = "cw_ak74"},
			["AR15"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_m4a1.mdl", Price = 30000, ClassName = "cw_ar15"},
			["XM8"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_m4a1.mdl", Price = 32500, ClassName = "cw_g4p_xm8"},

			["M3"] 							= BaseWars.GSL{Gun = true, Model = "models/weapons/w_shot_m3super90.mdl", Price = 50000, ClassName = "cw_m3super90"},

			["G3A3"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_snip_g3sg1.mdl", Price = 90000, ClassName = "cw_g3a3"},
			["AWM"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_snip_awp.mdl", Price = 100000, ClassName = "cw_g4p_awm"},
			["M98b"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_snip_sg550.mdl", Price = 125000, ClassName = "cw_g4p_m98b"},


	}

	BaseWars.SpawnList.Models.Loadout["Ammo Kits"] = {

		["Kit"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 5000, ClassName = "cw_ammo_kit_small"},
		["Crate"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 35000, ClassName = "cw_ammo_crate_small"},
		["40mm Grenades"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 35000, ClassName = "cw_ammo_40mm"},
		["Frag Grenades"] = BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 45000, ClassName = "cw_ammo_fraggrenades"},

	}

	--[[BaseWars.SpawnList.Models.Loadout["Attachments"] = {
		["General - Suppresors"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_suppressors"},
		["General - Attachments"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_various"},
		["General - Rails"]				= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "x_cw_extra_g4p_railpack"},
		["General - UECW"]				= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "x_cw_extra_g4p_attpack"},
		["Sights - Long"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_longrange"},
		["Sights - Mid"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_midrange"},
		["Sights - Sniper"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_sniper"},
		["Sights - CQC"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_cqb"},
		["Ammo - Shotgun"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ammotypes_shotguns"},
		["Ammo - General"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ammotypes_rifles"},
		["Barrels - AK74"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_barrels"},
		["Barrels - AR15"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_barrels"},
		["Barrels - AR15 (Long)"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_barrels_large"},
		["Barrels - Deagle"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_deagle_barrels"},
		["Barrels - MP5"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_barrels"},
		["Barrels - MR96"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mr96_barrels"},
		["Stocks - MP5"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_stocks"},
		["Stocks - AR15"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_stocks"},
		["Stocks - AK74"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_stocks"},
		["Misc - MP5"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_misc"},
		["Misc - AK74"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_misc"},
		["Misc - AR15"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_misc"},
	}]]
else
	BaseWars.SpawnList.Models.Loadout["Weapons - T1"] = {

			["Crowbar"] 				= BaseWars.GSL{Gun = true, Model = "models/weapons/w_crowbar.mdl", Price = 3000, ClassName = "weapon_crowbar"},

			["USP"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_usp.mdl", Price = 5000, ClassName = "weapon_twitch_usp"},
			["Deagle"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_deagle.mdl", Price = 10000, ClassName = "weapon_twitch_deagle"},

			["UMP"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_ump45.mdl", Price = 10000, ClassName = "weapon_twitch_ump45"},
			["MP5"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_mp5.mdl", Price = 12500, ClassName = "weapon_twitch_mp5"},

			["AR2"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 13250, ClassName = "weapon_twitch_hl2pulserifle"},
			["P90"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_p90.mdl", Price = 13000, ClassName = "weapon_twitch_p90"},
			["Galil"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_galil.mdl", Price = 13000, ClassName = "weapon_twitch_galil"},
			["AK47"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_ak47.mdl", Price = 13250, ClassName = "weapon_twitch_ak47"},
			["M4A1"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_m4a1.mdl", Price = 13250, ClassName = "weapon_twitch_m4"},

			["M3"] 							= BaseWars.GSL{Gun = true, Model = "models/weapons/w_shot_m3super90.mdl", Price = 35000, ClassName = "weapon_twitch_m3"},

		}
end

BaseWars.SpawnList.Models.Entities["Generators (T1)"] = {

	["Solar Panel"]					= BaseWars.GSL{Model = "models/props_lab/miniteleport.mdl", Price = 1500, ClassName = "bw_gen_solar"},
	["Coal Fired Generator"]		= BaseWars.GSL{Model = "models/props_wasteland/laundry_washer003.mdl", Price = 20000, ClassName = "bw_gen_coalfired", Level = 3},
	["Fission Reactor"]				= BaseWars.GSL{Model = "models/props/de_nuke/equipment1.mdl", Price = 75000, ClassName = "bw_gen_fission", Level = 5},
	["Fusion Reactor"]				= BaseWars.GSL{Model = "models/xqm/hydcontrolbox.mdl", Price = 300000, ClassName = "bw_gen_fusion", Level = 10},

}

BaseWars.SpawnList.Models.Entities["Dispensers (T1)"] = {

	["Vending Machine"]				= BaseWars.GSL{Model = "models/props_interiors/VendingMachineSoda01a.mdl", Price = 20000, ClassName = "bw_vendingmachine"},
	["Ammo Dispenser"]				= BaseWars.GSL{Model = "models/props_lab/reciever_cart.mdl", Price = 55000, ClassName = "bw_dispenser_ammo"},
	["Armour Dispenser"]			= BaseWars.GSL{Model = "models/props_combine/suit_charger001.mdl", Price = 35000, ClassName = "bw_dispenser_armor"},
	["Printer-Paper Refiller"]		= BaseWars.GSL{Model = "models/props_lab/plotter.mdl", Price = 550000, ClassName = "bw_dispenser_paper", Limit = 1, Level = 8},
	["HealthPad"]					= BaseWars.GSL{Model = "models/props_lab/teleplatform.mdl", Price = 50000, ClassName = "bw_healthpad", UseSpawnFunc = true},

}

BaseWars.SpawnList.Models.Entities["Structures (T1)"] = {

	-- T1
	["Spawnpoint"]					= BaseWars.GSL{Model = "models/props_trainstation/trainstation_clock001.mdl", Price = 15000, ClassName = "bw_spawnpoint", UseSpawnFunc = true},
	["Drug Lab"]					= BaseWars.GSL{Model = "models/props_lab/crematorcase.mdl", Price = 35000, ClassName = "bw_druglab"},

}

BaseWars.SpawnList.Models.Entities["Structures (T2)"] = {

	-- T2
	["Radar"]						= BaseWars.GSL{Model = "models/props_rooftop/roof_dish001.mdl", Price = 25000000, ClassName = "bw_radar",  Limit = 1, Level = 35},

}

BaseWars.SpawnList.Models.Entities["Defense (T1)"] = {

	-- T1
	["Ballistic Turret"] 			= BaseWars.GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 80000, ClassName = "bw_turret_ballistic", Limit = 2, Level = 15},
	["Laser Turret"] 				= BaseWars.GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 120000, ClassName = "bw_turret_laser", Limit = 1, Level = 18},

}

BaseWars.SpawnList.Models.Entities["Defense (T2)"] = {

	-- T2
	["Tesla Coil"]					= BaseWars.GSL{Model = "models/props_c17/substation_transformer01d.mdl", Price = 5000000, ClassName = "bw_tesla", Limit = 1, Level = 30},

}

BaseWars.SpawnList.Models.Entities["Consumables (T1)"] = {

	["Repair Kit"]					= BaseWars.GSL{Model = "models/Items/car_battery01.mdl", Price = 2500, ClassName = "bw_repairkit", UseSpawnFunc = true},
	["Armour Kit"]					= BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 22500, ClassName = "bw_entityarmor", UseSpawnFunc = true},
	["Capacity Kit"]				= BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 100000, ClassName = "bw_printercap", UseSpawnFunc = true},
	["Battery Kit"]					= BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 80000, ClassName = "bw_battery", UseSpawnFunc = true},
	["Printer Paper"]				= BaseWars.GSL{Model = "models/props_junk/garbage_newspaper001a.mdl", Price = 300, ClassName = "bw_printerpaper", UseSpawnFunc = true},

}

BaseWars.SpawnList.Models.Entities["Printers (T1)"] = {

	-- T1
	["Basic Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 2000, ClassName = "bw_base_moneyprinter"},
	["Copper Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 12500, ClassName = "bw_printer_copper", Level = 3},
	["Silver Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 20000, ClassName = "bw_printer_silver", Level = 5},
	["Gold Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 50000, ClassName = "bw_printer_gold", Level = 7},
	["Platinum Printer"]			= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 75000, ClassName = "bw_printer_platinum", Level = 9},
	["Diamond Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 150000, ClassName = "bw_printer_diamond", Level = 11},
	["Nuclear Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 300000, ClassName = "bw_printer_nuclear", Level = 13},

}

BaseWars.SpawnList.Models.Entities["Printers (T2)"] = {

	-- T2
	["Mobius Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 6000000, ClassName = "bw_printer_mobius", Level = 50},
	["Dark Matter Printer"]			= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 15000000, ClassName = "bw_printer_darkmatter", Level = 60},
	["Red Matter Printer"]    		= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 25000000, ClassName = "bw_printer_redmatter", Level = 70},
	["Monolith Printer"]      		= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 35000000, ClassName = "bw_printer_monolith", Level = 80},
	["Quantum Printer"]       		= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 55000000, ClassName = "bw_printer_quantum", Level = 90},

}

BaseWars.SpawnList.Models.Loadout["Drugs"] = {

	["DoubleJump"] 					= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "DoubleJump"},
	["Regen"] 						= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "Regen"},
	["PainKiller"] 					= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "PainKiller"},
	["Steroid"] 					= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "Steroid"},
	["Adrenaline"] 					= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "Adrenaline"},
	["Rage"] 						= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "Rage"},
	["Shield"] 						= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "Shield"},
	["Antidote"]					= BaseWars.GSL{Drug = true, Price = 25000, ClassName = "Antidote"},

}

BaseWars.SpawnList.Models.Loadout["Weapons - T2"] = {

	["Heal Gun"]					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_physics.mdl", Price = 350000, ClassName = "weapon_health", Level = 20},
	["Frag"]						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_grenade.mdl", Price = 45000, ClassName = "weapon_frag", Level = 20},
	["Gas grenade"]						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_eq_flashbang_thrown.mdl", Price = 150000, ClassName = "bw_gasnade", Level = 50},

}
