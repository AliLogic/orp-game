--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

local borkui = ImportPackage("borkui")
local colour = ImportPackage("colours")

-- Commands

AddCommand("furniture", function (playerid)

	local houseid = Housing_Nearest(playerid)

	if houseid == 0 or (not House_IsOwner(playerid, houseid) and not PlayerHasHouseKey(playerid, houseid))then
		return AddPlayerChat(playerid, "You are not in range of your house interior.")
	end

	borkui.createUI(playerid, 0, DIALOG_FURNITURE_MENU)
end)

AddCommand("gotofurniture", function (playerid, furnitureid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if furnitureid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotofurnitureid <furniture>")
	end

	furnitureid = tonumber(furnitureid)

	if not IsValidFurniture(furnitureid) then
		return AddPlayerChatError(playerid, "Furniture " .. furnitureid .. " doesn't exist.")
	end

	local x, y, z = GetFurnitureLocation(furnitureid)
	SetPlayerLocation(playerid, x, y, z)

	AddPlayerChat(playerid, "You have been teleported to furniture ID: " .. furnitureid ..".")
end)