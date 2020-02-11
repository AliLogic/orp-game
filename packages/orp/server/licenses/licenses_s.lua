--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

LICENSE_TYPE_GDL = 1
LICENSE_TYPE_CDL = 2
LICENSE_TYPE_BL = 3
LICENSE_TYPE_PF = 4
LICENSE_TYPE_MML = 5
LICENSE_TYPE_PL = 6

PlayerLicenseData = {}

LicensesNames = {
	"General Driving License",
	"Commercial Driving License",
	"Boat License",
	"Permit to Purchase and use Firarms",
	"Medical Marijuana License",
	"Pilot License"
}

LicensesColumns = {
	"GDL",
	"CDL",
	"BL",
	"PF",
	"MML",
	"PL"
}

-- Functions

function CreatePlayerLicenseData(playerid)

	PlayerLicenseData[playerid] = {}
	for i = 1, 6, 1 do
		PlayerLicenseData[playerid][i] = 0
	end
end

function DestroyPlayerLicenseData(playerid)
	PlayerLicenseData[playerid] = nil
end

function GetPlayerLicense(playerid, license)

	return PlayerLicenseData[playerid][license]
end

function SetPlayerLicense(playerid, license, status)

	PlayerLicenseData[playerid][license] = status

	local query = mariadb_prepare(sql, "UPDATE licenses SET "..LicensesColumns[license].." = "..status.." WHERE id = "..PlayerData[playerid].id.."")
	mariadb_async_query(sql, query)
end

local function OnLoadPlayerLicenses(playerid)

	if mariadb_get_row_count() ~= 0 then
		mariadb_get_value_index_int(1, "GDL", PlayerLicenseData[playerid].LICENSE_TYPE_GDL)
		mariadb_get_value_index_int(1, "CDL", PlayerLicenseData[playerid].LICENSE_TYPE_CDL)
		mariadb_get_value_index_int(1, "BL", PlayerLicenseData[playerid].LICENSE_TYPE_BL)
		mariadb_get_value_index_int(1, "PF", PlayerLicenseData[playerid].LICENSE_TYPE_PF)
		mariadb_get_value_index_int(1, "MML", PlayerLicenseData[playerid].LICENSE_TYPE_MML)
		mariadb_get_value_index_int(1, "PL", PlayerLicenseData[playerid].LICENSE_TYPE_PL)
	else
		local query = mariadb_prepare(sql, "INSERT INTO licenses WHERE id = "..PlayerData[playerid].id.."")
		mariadb_async_query(sql, query)
	end
end

function LoadPlayerLicenses(playerid)

	CreatePlayerLicenseData(playerid)

	local query = mariadb_prepare(sql, "SELECT * FROM licenses WHERE id = "..PlayerData[playerid].id.."")
	mariadb_async_query(sql, query, OnLoadPlayerLicenses, playerid)
end