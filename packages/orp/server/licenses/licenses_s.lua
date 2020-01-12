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

-- Functions

function CreatePlayerLicenseData(playerid)
	PlayerLicenseData[playerid] = {
		LICENSE_TYPE_GDL = 0,
		LICENSE_TYPE_CDL = 0,
		LICENSE_TYPE_BL = 0,
		LICENSE_TYPE_PF = 0,
		LICENSE_TYPE_MML = 0,
		LICENSE_TYPE_PL = 0
	}
end

function DestroyPlayerLicenseData(playerid)
	PlayerLicenseData[playerid] = nil
end

function GetPlayerLicense(playerid, license)

	return PlayerLicenseData[playerid][license]
end

function SetPlayerLicense(playerid, license, status)

	PlayerLicenseData[playerid][license] = status

	local query = mariadb_prepare(sql, "UPDATE licenses SET "..license.." = "..status.." WHERE id = "..PlayerData[playerid].id.."")
	mariadb_async_query(sql, query)
end