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

	local
		houseid = 0

	--[[
		Add a check to see if the player is inside the house or not
	if houseid == 0 then
		return AddPlayerChat(playerid, "You are not in range of your house interior.")
	end
	]]--

	local
		count = 0
	local
		string = ""
	local
		x, y, z = GetPlayerLocation(playerid)
	local
		distance = 0
	local
		fx, fy, fz = 0

	for i = 1, MAX_FURNITURE, 1 do
		if (IsValidFurniture(i)) then
			if (count < MAX_HOUSE_FURNITURE and GetFurnitureHouseID(i) == houseid) then

				fx, fy, fz = GetFurnitureLocation(i)
				distance = GetDistance3D(x, y, z, fx, fy, fz)

				string = string .. GetFurnitureNameByModel(i) .. "(" .. distance .. " meters)"
			end

			if (count == 0) then
				return AddPlayerChat(playerid, "This house doesn't have any furniture spawned in.")
			end

			borkui.createUI(playerid, 0, DIALOG_HOME_FURNITURE)
			-- Show them the listed furniture dialog
		end
	end
end)