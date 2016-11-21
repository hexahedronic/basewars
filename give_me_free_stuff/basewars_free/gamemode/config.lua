BASEWARS_CHOSEN_LANGUAGE = "ENGLISH"

BaseWars.Config = {
	Forums 		= "https://scriptfodder.com/scripts/view/3309",
	SteamGroup 	= "https://scriptfodder.com/scripts/view/3309",

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
		HTML	= "https://scriptfodder.com/scripts/view/3309",
	},

	Adverts = {
		Time = 120,
	},

	SpawnWeps = {
		"weapon_physcannon",
		"hands",
	},

	WeaponDropBlacklist = {
	},

	PhysgunBlockClasses = {
	},

	BlockedTools = {
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

BaseWars.NPCTable[game.GetMap()] = {{Pos = Vector(0, 0, 0), Ang = Angle(0, 0, 0)}}

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
	
	["Why should I buy this gamemode when it's free?"] = {
	
		"The free version is no longer supported.",
		"This version also includes MASSIVE exploits and bugs.",
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
