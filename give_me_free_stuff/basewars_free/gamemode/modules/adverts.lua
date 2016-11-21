MODULE.Name 	= "Adverts"
MODULE.Author 	= "Q2F2"
MODULE.Realm 	= 2

local tag = "BaseWars.Adverts"

function MODULE:__INIT()

	function MODULE:DisplayRandomAdvert()

		local Advert = table.Random(BaseWars.AdvertTbl)
		
		chat.AddText(unpack(Advert))

	end
	timer.Create(tag, BaseWars.Config.Adverts.Time, 0, Curry(MODULE.DisplayRandomAdvert))

end
