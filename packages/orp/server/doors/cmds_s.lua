local colour = ImportPackage('colours')

local function cmd_acd(playerid, modelid)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if modelid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(d)oor <model>")
	end

	modelid = tonumber(modelid)

	if modelid < 1 or modelid > 81 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Model must be between 1 to 40.")
	end

	local x, y, z = GetPlayerLocation(playerid)
	local dimension = GetPlayerDimension(playerid)

	local doorid = Door_Create(modelid, x, y, z, dimension)
	if doorid == false then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Door "..modelid.." wasn't able to be created!</>")
	else
		AddPlayerChat(playerid, string.format("<span color=\"%s\">Server: </>Door %d (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), modelid, doorid))
	end
	return
end

AddCommand("acreatedoor", cmd_acd)
AddCommand("acd", cmd_acd)

local function cmd_add(playerid, doorid)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if doorid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ad)estroy(d)oor <door>")
	end

	doorid = tonumber(doorid)

	if Door_Destroy(doorid) == false then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Door "..doorid.." wasn't able to be destroyed!</>")
	else
		AddPlayerChat(playerid, string.format("<span color=\"%s\">Server: </>Door %d destroyed successfully!", colour.COLOUR_LIGHTRED(), doorid))
	end
end

AddCommand("adestroydoor", cmd_add)
AddCommand("add", cmd_add)

local function cmd_aed(playerid, doorid, prefix, ...)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if doorid == nil or prefix == nil then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(d)oor <door> <prefix>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> location, lock")
	end

	doorid = tonumber(doorid)

	if IsValidDoor(doorid) == false then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Door "..doorid.." doesn't exist.</>")
	end

	if prefix == "location" then
		local x, y, z = GetPlayerLocation(playerid)
		local a = GetPlayerHeading(playerid)
		local dimension = GetPlayerDimension(playerid)

		DoorData[doorid].x = x
		DoorData[doorid].y = y
		DoorData[doorid].z = z
		DoorData[doorid].a = a
		DoorData[doorid].dimension = dimension

		SetDoorLocation(DoorData[doorid].door, x, y, z)
		SetPickupDimension(DoorData[doorid].door, dimension)

		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Door "..doorid.." location changed.</>")
	elseif prefix == "lock" then

		local is_locked = not DoorData[doorid].is_locked

		SetPlayerAnimation(playerid, "LOCKDOOR")
		if is_locked == 1 then
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Door "..doorid.." is now locked.</>")
			SetDoorOpen(DoorData[doorid].door, false)
			DoorData[doorid].is_locked = 1
		else
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Door "..doorid.." is now unlocked.</>")
			DoorData[doorid].is_locked = 0
		end
		return
	else
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(d)oor <door> <prefix>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> location, lock")
	end
end

AddCommand("aeditdoor", cmd_aed)
AddCommand("aed", cmd_aed)

AddCommand("gotodoor", function (playerid, doorid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if doorid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotodoor <door>")
	end

	doorid = tonumber(doorid)

	if DoorData[doorid] == nil then
		return AddPlayerChatError(playerid, "Door " .. doorid .. "doesn't exist.")
	end

	SetPlayerLocation(playerid, DoorData[doorid].x, DoorData[doorid].y, DoorData[doorid].z)

	AddPlayerChat(playerid, "You have been teleported to door ID: " .. doorid ..".")
end)