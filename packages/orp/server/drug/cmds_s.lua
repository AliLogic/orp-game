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

	if DrugData[plantid].stage ~= 10 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This plant is not ready to be harvested yet.</>")
	end

	local type = GetPlantTypeId(plantid)
	local amount = Random(DRUG_TYPE_AMOUNT[type][1], DRUG_TYPE_AMOUNT[type][2])

	AddPlayerChat(plantid, "You have harvested "..amount.." gm of "..GetPlantTypeName(plantid)..".")
	Inventory_GiveItem(playerid, DRUG_TYPE_ITEM[type], amount)

	Plant_Destroy(plantid)

	return
end)

AddCommand("plant", function (playerid, drug)

	if drug == nil then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /plant <drug>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Drug:</> marijuana, cocaine")
	end

	local slot = false
	local x, y, z = GetPlayerLocation(playerid)

	drug = string.lower(drug)

	if drug == "marijuana" then

		slot = Inventory_HasItem(playerid, INV_ITEM_WEEDSEED)
		if slot == false then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You do not have any of these seeds.</>")
		end

		Inventory_GiveItem(playerid, INV_ITEM_WEEDSEED, -1)
		CreatePlant(DRUG_TYPE_WEED, x, y, z)
	elseif drug == "cocaine" then

		slot = Inventory_HasItem(playerid, INV_ITEM_COKESEED)
		if slot == false then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You do not have any of these seeds.</>")
		end

		Inventory_GiveItem(playerid, INV_ITEM_COKESEED, -1)
		CreatePlant(DRUG_TYPE_COKE, x, y, z)
	else

		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /plant <drug>")
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Drug:</> marijuana, cocaine")
	end

	return
end)