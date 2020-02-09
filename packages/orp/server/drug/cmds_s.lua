--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')

-- Commands

AddCommand("harvest", function (playerid)

	local plantid = 0

	plantid = Plant_Nearest(playerid)
	if plantid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any plants.</>")
	end

	if not DRUG_STAGES[DrugData[plantid].stage + 1] then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This plant is not ready to be harvested yet.</>")
	end

	local type = GetPlantTypeId(plantid)
	local amount = Random(DRUG_TYPE_AMOUNT[type][0], DRUG_TYPE_AMOUNT[type][1])

	AddPlayerChat(plantid, "You have harvested "..amount.." gm of "..GetPlantTypeName(plantid)..".")
	Inventory_GiveItem(playerid, DRUG_TYPE_ITEM[type], amount)

	Plant_Destroy(plantid)

	return
end)