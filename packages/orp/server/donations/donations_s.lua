--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

DonationData = {}

-- Functions

local function CreateDonationData(playerid)

	DonationData[playerid] = {}

	DonationData[playerid].level = 0
	DonationData[playerid].date = 0
end

local function DestroyDonationData(playerid)

	DonationData[playerid] = nil
end

function OnDonationsLoaded(playerid)

	CreateDonationData(playerid)

	if mariadb_get_row_count() == 0 then

		DonationData[playerid].level = 0
		DonationData[playerid].date = 0

	else

		DonationData[playerid].level = mariadb_get_value_name_int(1, "level")
		DonationData[playerid].date = mariadb_get_value_name_int(1, "date")
	end
end

-- Events

AddEvent("OnPlayerSteamAuth", function (playerid)
	CreateDonationData(playerid)
end)

AddEvent("OnPlayerQuit", function (playerid)
	DestroyDonationData(playerid)
end)