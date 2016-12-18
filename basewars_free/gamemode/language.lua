local CURRENCY = "£"
BaseWars.LANG = {}
BaseWars.LANG.__LANGUAGELOOK = {}

BaseWars.LANG.__LANGUAGELOOK.ENGLISH = {
	CURRENCY								= CURRENCY,

	Yes											= "Yes",
	No											= "No",
	Level										= "Level",
	Remaining								= "Remaining",
	Seconds									= "Seconds",
	Mins										= "Mins",

	FactionNameTaken				= "This faction name is already in use!",
	FactionNotExist					= "That faction does not exist!",
	FactionCantDisband			= "Only the faction leader can disband the faction!",
	FactionWrongPass				= "That is not the correct password!",
	FactionCantLeaveLeader	= "You cannot leave the faction as its leader, you must disband it!",
	FactionCantPassword			= "Only the faction leader can re-password the faction!",

	PayDay									= "PayDay! You received " .. CURRENCY .. "%s!",

	DontBuildSpawn					= "Do not build props around spawn.",
	SpawnKill								= "Do not attempt to spawnkill.",
	SpawnCamp								= "Do not attempt to spawncamp.",

	RaidOngoing							= "There is already a raid ongoing!",
	RaidSelfUnraidable			= "You are not raidable yourself! (%s)",
	RaidTargetUnraidable		= "Your target is not raidable! (%s)",
	RaidOver								= "The raid between %s and %s has ENDED!",
	RaidStart								= "A raid started between %s and %s!",
	RaidTargNoFac						= "You cannot raid a factionless player as a faction!",
	RaidSelfNoFac						= "You cannot raid a faction as a factionless player!",
	RaidNoFaction						= "You cannot use faction functions during a raid!",
	CantRaidSelf						= "You can't raid yourself or your faction!",

	CannotPurchaseRaid			= "You cannot purchase that in a raid!",

	NoPrinters							= "Not enough raidable printers!",
	OnCoolDown							= "Currently on CoolDown from being raided!",

	PayOutOwner							= "You got " .. CURRENCY .. "%s for the destruction of your %s!",
	PayOut									= "You got " .. CURRENCY .. "%s for destroying a %s!",

	SteroidEffect						= "You feel full of energy...",
	SteroidRemove						= "Your energy passes...",
	RegenEffect							= "You feel your wounds healing by themselves...",
	RegenRemove							= "Your flesh ceases to heal...",
	PainKillerEffect				= "You feel no pain...",
	PainKillerRemove				= "You once again feel pain...",
	AntidoteEffect					= "You feel very healthy, and less afflicted by poison...",
	AntidoteRemove					= "You no longer feel very healthy...",
	AdrenalineEffect				= "YOU FEEL REALLY PUMPED...",
	AdrenalineRemove				= "You no longer feel pumped...",
	DoubleJumpEffect				= "You feel very light...",
	DoubleJumpRemove				= "You suddenly feel like lead...",
	ShieldEffect						= "You feel energy gathering around you...",
	ShieldRemove						= "The energy that previously protected you disipates...",
	ShieldSave							= "The person you attacked was saved by an energy shield.",
	RageEffect							= "KIIIIIIILLLLLLLLLLLL!!!",
	RageRemove							= "Whoa, that was a bit much wasn't it...",

	PowerFailure						= "NO POWER!",
	HealthFailure						= "CRITICAL DAMAGE!",

	NewSpawnPoint						= "Your new SpawnPoint has been set!",

	UseSpawnMenu						= "Use the BaseWars spawnlist!",
	SpawnMenuMoney					= "You don't have enough money for that.",
	SpawnMenuBuy						= "You bought a(n) \"%s\" for " .. CURRENCY .. "%s.",
	SpawnMenuBuyConfirm			= "Are you sure you want to by a(n) \"%s\" for " .. CURRENCY .. "%s?",
	SpawnMenuConf						= "Purchase Confirmation",
	DeadBuy									= "Dead people buy nothing.",
	EntLimitReached					= "You have reached the limit of \"%s\"s.",

	StuckText								= "You are stuck inside a wall, prop, or player! Remain calm and press [CTRL], if it does not work press [SPACE].",

	FailedToAuth						= "Steam failed to authenticate your SteamID, uh oh!",

	MainMenuControl					= "F3 - Open Main Menu (Rules, Factions, Raids)",
	SpawnMenuControl				= " - Open Buy Menu (Entities, Weapons)", -- Key is detected automatically, do not add one.
	KarmaText								= "Your Karma is currently %s",
	LevelText               = "Level: %s",
	XPText                  = "%s/%s XP",

	AFKFor									= "You have been away for",
	RespawnIn								= "You can respawn in",

	UpgradeNoMoney					= "You don't have enough money to upgrade!",
	UpgradeMaxLevel					= "You can't upgrade this printer any more!",

	WelcomeBackCrash				= "Welcome back, the last time you played we crashed.",
	Refunded								= "You have been refunded " .. CURRENCY .. "%s.",

	GivenMoney							= "%s gave you " .. CURRENCY .. "%s.",
	GaveMoney								= "You gave %s " .. CURRENCY .. "%s.",

	BountyNotEnoughMoney		= "You don't have enough money to place bounty.",

	InvalidPlayer						= "Invalid Player!",
	InvalidAmount						= "Invalid Amount!",
	TooPoor									= "You're too poor for this transaction!",
}

local INVALID_LANGUAGE	= "INVALID LANGUAGE SELECTED! NOTIFY THE SERVER ADMIN!"
local INVALID_STRING		= "INVALID STRING TRANSLATION! NOTIFY THE SERVER ADMIN!"

setmetatable(BaseWars.LANG, {
	__index = function(t, k)

		local L = BaseWars.LANG.__LANGUAGELOOK[BASEWARS_CHOSEN_LANGUAGE]
		if not L then
			return INVALID_LANGUAGE
		end
		if not L[k] then
			ErrorNoHalt("[BaseWars-Lang] You messed up a string localization:")
			debug.Trace()

			return INVALID_STRING
		end
		return L[k]

	end
})
