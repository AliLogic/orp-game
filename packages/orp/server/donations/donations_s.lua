--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')
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

	if mariadb_get_row_count() == 0 then

		DonationData[playerid].level = 0
		DonationData[playerid].date = 0

	else

		DonationData[playerid].level = mariadb_get_value_name_int(1, "level")
		DonationData[playerid].date = mariadb_get_value_name_int(1, "time")

		if os.time(os.date("!*t")) < DonationData[playerid].date then
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Your donation level " .. DonationData[playerid].level .. " is active till " .. os.date("%d %B %Y", DonationData[playerid].date) .. ". Thank you for helping and supporting us!</>")
		else
			AddPlayerChat(playerid, "<span color=\""..colour.COLOR_LIGHTRED()"\">Your donation level " .. DonationData[playerid].level .. " expired on " .. os.date("%d %B %Y", DonationData[playerid].date) .. ". Please consider visiting the UCP for more information.</>")

			DonationData[playerid].level = 0
		end
	end
end

function AddPlayerChatDonator(text)

	for _, v in ipairs(GetAllPlayers()) do
		if DonationData[v] ~= nil then
			if DonationData[v].level ~= 0 then
				AddPlayerChat(v, text)
			end
		end
	end
end

-- Events

AddEvent("OnPlayerSteamAuth", function (playerid)
	CreateDonationData(playerid)
end)

AddEvent("OnPlayerQuit", function (playerid)
	DestroyDonationData(playerid)
end)