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

DialogString = ""
DIALOG_FACTION_ONLINE = 1
DIALOG_TICKETS_PAY = 2
DIALOG_WHITELIST_LOG = 3
DIALOG_BAN_LOG = 4
DIALOG_HOME_FURNITURE = 5

DIMENSION_IMPOUND = 500

LOC_DRIVINGTEST_X = 195320
LOC_DRIVINGTEST_Y = 207826
LOC_DRIVINGTEST_Z = 1250

-- Functions

function GetLocationName(x, y, z)

	local locations = {
		{"Nevada",				{0.0, 0.0, 0.0, 0.0, 0.0, 0.0}}, --[[ -269513, -225764, -30, 221220, 134652, 62000 ]]--
		{"State Prison",		{-190813, 64752, 1500, -162363, 88169, 62000}}
	}

	for i = 2, #locations, 1 do
		if locations[i][2] <= x and locations[i][3] <= y and locations[i][4] <= z and locations[i][5] >= x and locations[i][6] >= y and locations[i][7] >= z then
			return locations[i][1]
		end
	end

	return locations[1][1]
end

function GetPlayerLocationName(playerid)

	local x, y, z = GetPlayerLocation(playerid)

	return GetLocationName(x, y, z)
end

function IsPlayerInRangeOfPoint(playerid, range, x, y, z)

	local px, py, pz = GetPlayerLocation(playerid)

	if (GetDistance3D(x, y, z, px, py, pz) <= range) then
		return true
	end

	return false
end

function FreezePlayer(player, status)
	return CallRemoteEvent(player, "FreezePlayer", status)
end

function IsPlayerInRangeOfPlayer(playerid, lookupid)

	if not IsValidPlayer(playerid) or not IsValidPlayer(lookupid) then
		return 0
	end

	local x, y, z = GetPlayerLocation(playerid)
	local x2, y2, z2 = GetPlayerLocation(lookupid)

	if GetDistance3D(x, y, z, x2, y2, z2) >= 140.0 then
		return 0
	end

	return 1
end

function Slap(player)
	local x, y, z = GetPlayerLocation(player)
	SetPlayerLocation(player, x, y, z + 200)
end

function ViewPlayerStats(player, target)
	target = tonumber(target)

	AddPlayerChat(player, string.format("<span color=\"%s\">|__________________%s [%s]__________________|</>", 
		colour.COLOUR_DARKGREEN(), GetPlayerName(target), PlayerData[target].name)) -- in future, add time.

	AddPlayerChat(player, string.format("<span color=\"%s\">CHARACTER: Gender:[%s] CharID:[%d]</>",
		colour.COLOUR_GRAD2(), (PlayerData[target].gender == 0 and 'Male' or 'Female'), PlayerData[player].id))

	AddPlayerChat(player, string.format("<span color=\"%s\">CHARACTER: LEVEL:[%d] EXP:[%d/%d]</>",
		colour.COLOUR_GRAD2(), PlayerData[target].level, PlayerData[target].exp, (PlayerData[target].exp * 4) + 2))

	AddPlayerChat(player, string.format("<span color=\"%s\">MONEY: Cash:[$%d] Bank:[$%d]</>",
		colour.COLOUR_GRAD1(), PlayerData[target].cash, PlayerData[target].bank))

	if PlayerData[target].admin > 0 then
		AddPlayerChat(player, string.format("<span color=\"%s\">ADMIN: DBID:[%d] Dimension:[%d] Locale:[%s]</>",
			colour.COLOUR_LIGHTRED(), PlayerData[target].accountid, GetPlayerDimension(target), GetPlayerLocale(target)))

		AddPlayerChat(player, string.format("<span color=\"%s\">CONNECTION: IP:[%s]</>",
			colour.COLOUR_LIGHTRED(), GetPlayerIP(target)))
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">|__________________%s [%s]__________________|</>",
		colour.COLOUR_DARKGREEN(), GetPlayerName(target), PlayerData[target].name)) -- in future, add time.
end

function SetPlayerChatBubble(player, message, seconds)
	if PlayerData[player].label ~= nil then
		if IsValidText3D(PlayerData[player].label) then
			DestroyText3D(PlayerData[player].label)
		end
	end

	PlayerData[player].label = CreateText3D(message, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetText3DAttached(PlayerData[player].label, ATTACH_PLAYER, player, 0.0, 0.0, 190.0)

	--[[Delay(seconds * 1000, function (player)
		if PlayerData[player].label ~= nil then
			if IsValidText3D(PlayerData[player].label) then
				DestroyText3D(PlayerData[player].label)
			end
		end
	end)]]

	Delay(seconds * 1000, function ()
		if PlayerData[player].label ~= nil then
			if IsValidText3D(PlayerData[player].label) then
				DestroyText3D(PlayerData[player].label)
			end
		end
	end)
end

function GetPlayerCash(player)
	if PlayerData[player] ~= nil then
		return PlayerData[player].cash
	end
end

function SetPlayerCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].cash = amount
		SetGUICash(player, amount)
	end
end

function AddPlayerCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].cash = PlayerData[player].cash + amount
		SetGUICash(player, PlayerData[player].cash)
	end
end

function RemovePlayerCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].cash = PlayerData[player].cash - amount
		SetGUICash(player, PlayerData[player].cash)
	end
end

function SetPlayerBankCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].bank = amount
		SetGUIBank(player, PlayerData[player].bank)
	end
end

function AddPlayerBankCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].bank = amount
		SetGUIBank(player, PlayerData[player].bank)
	end
end

function RemovePlayerBankCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].bank = amount
		SetGUIBank(player, PlayerData[player].bank)
	end
end

function SetPlayerHandcuff(playerid, bToggle)

	PlayerData[playerid].handcuffed = bToggle
	if bToggle then
		SetPlayerAnimation(playerid, "CUFF")
	else
		SetPlayerAnimation(playerid, "STOP")
	end
end

function IsPlayerHandcuffed(playerid)
	if PlayerData[playerid] ~= nil then
		return PlayerData[playerid].handcuffed
	end
	return 0
end

function IsPlayerAlive(playerid)
	if PlayerData[playerid] ~= nil then
		return (PlayerData[playerid].state == CHARACTER_STATE_ALIVE)
	end
	return false
end

function IsVehicleSeatUsed(vehicleid, seat)

	for k, v in pairs(GetAllPlayers()) do
		if GetPlayerVehicle(v) == vehicleid and GetPlayerVehicleSeat(v) == seat then
			return true
		end
	end
	return false
end

function GetAvailableSeat(vehicleid, start)
	if start == nil then
		start = 1
	end

	local seats = GetVehicleNumberOfSeats(vehicleid);

	for i = start, seats, 1 do
		if (not IsVehicleSeatUsed(vehicleid, i)) then
			return i
		end
	end

	return 0
end

function ShowPropertiesList(playerid, lookupid)
	local count = 0

	for houseid = 1, MAX_HOUSING, 1 do
		if House_IsOwner(lookupid, houseid) == true then

			AddPlayerChat(playerid, "* House ID: ".. houseid .." | Address: ".. HousingData[houseid].address .. ".")

			count = count + 1
		end
	end

	for businessid = 1, MAX_BUSINESSES, 1 do

		if Business_IsOwner(lookupid, businessid) == true then

			AddPlayerChat(playerid, "* Business ID: ".. businessid ..".")

			count = count + 1
		end
	end

	if count == 0 then
		if playerid == lookupid then
			AddPlayerChat(playerid, "You do not own any properties.")
		else
			AddPlayerChat(playerid, ""..GetPlayerName(lookupid).." does not own any properties.")
		end
	end
end

AddRemoteEvent("GetPlayerCash", GetPlayerCash)
AddRemoteEvent("SetPlayerCash", SetPlayerCash)
AddRemoteEvent("AddPlayerCash", AddPlayerCash)
AddRemoteEvent("RemovePlayerCash", RemovePlayerCash)