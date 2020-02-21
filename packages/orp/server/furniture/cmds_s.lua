--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

local borkui = ImportPackage("borkui")

-- Commands

AddCommand("furniture", function (playerid)

	local houseid = Housing_Nearest(playerid)

	if houseid == 0 or (not House_IsOwner(playerid, houseid) and not PlayerHasHouseKey(playerid, houseid))then
		return AddPlayerChat(playerid, "You are not in range of your house interior.")
	end

	borkui.createUI(playerid, 0, DIALOG_FURNITURE_MENU)
end)