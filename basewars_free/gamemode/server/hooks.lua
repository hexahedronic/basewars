hook.Add("BaseWars_PlayerBuyEntity", "XPRewards", function(ply, ent)

	if ply:GetLevel() > 20 then return end

	local ent = BaseWars.Ents:Valid(ent)
	if not ent then return end

	local class = ent:GetClass()

	if class:match("bw_printer_") or class == "bw_base_moneyprinter" then

		local lvl = (ent.CurrentValue or 1000) / 1000
		ply:AddXP(55 * lvl)

	elseif class:match("bw_gen_") then

		ply:AddXP(125)

	elseif class == "bw_printerpaper" then

		ply:AddXP(25)

	end

end)

hook.Add("BaseWars_PlayerEmptyPrinter", "XPRewards", function(ply, ent, money)

	ply:AddXP(math.max(0, money / 500))

end)

timer.Create("BaseWars_KarmaRecover", 5 * 60, 0, function()

	for k, v in next, player.GetAll() do

		if v:GetKarma() < 0 then

			v:AddKarma(2)

		else

			v:AddKarma(1)

		end

	end

end)
