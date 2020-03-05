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

-- Variables

MAX_ATM = 50
ATMData = { }

local CONFIG_ATM = {
	withdraw = {
		min = 1,
		max = 2500
	},
	deposit = {
		min = 1,
		max = 1000
	}
}

-- Functions

local function CreateAtmData(index)

	ATMData[index] = {}

	ATMData[index].x = 0
	ATMData[index].y = 0
	ATMData[index].z = 0
end

local function GetFreeAtmId()

	for i = 1, MAX_ATM, 1 do
		if ATMData[i] == nil then
			CreateAtmData(i)
			return i
		end
	end

	return 0
end

local function OnAtmCreated(index, x, y, z, h)

	ATMData[index].id = mariadb_get_insert_id()

	ATMData[index].x = x
	ATMData[index].y = y
	ATMData[index].z = z

	ATMData[index].text3d = CreateText3D("ATM ("..ATMData[index].id..")\n/atm", 12, ATMData[index].x, ATMData[index].y, ATMData[index].z + 200, 0, 0, 0)
end

function ATM_Create(player, x, y, z, h)
	local index = GetFreeAtmId()
	if index == 0 then
		return false
	end

	local query = mariadb_prepare(sql, "INSERT INTO atm VALUES(?, ?, ?, ?, 0.0, ?, 0.0);", 494, x, y, z, h)
	mariadb_async_query(sql, query, OnAtmCreated, index, x, y, z, h)
end

function ATM_Nearest(playerid)
	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for v = 1, #ATMData, 1 do
		if ATMData[v] ~= nil then
			distance = GetDistance3D(x, y, z, ATMData[v].x, ATMData[v].y, ATMData[v].z)

			if distance <= 200.0 then
				return v
			end
		end
	end

	return 0
end

local function LoadATM(i)

	local index = GetFreeAtmId()

	if index == 0 then
		return false
	end

	local result = mariadb_get_assoc(i)

	ATMData[index].id = math.tointeger(result["id"])
	--local modelid = math.tointeger(result["modelid"])
	ATMData[index].x = tonumber(result["x"])
	ATMData[index].y = tonumber(result["y"])
	ATMData[index].z = tonumber(result["z"])
	--local rx = tonumber(result["rx"])
	--local ry = tonumber(result["ry"])
	--local rz = tonumber(result["rz"])

	ATMData[index].text3d = CreateText3D("ATM ("..ATMData[index].id..")\n/atm", 12, ATMData[index].x, ATMData[index].y, ATMData[index].z + 200, 0, 0, 0)
end

function OnAtmLoaded()
	for i = 1, mariadb_get_row_count() do
		LoadATM(i)
	end

	print("** ATMs Loaded: " .. #ATMData .. ".")
end

-- Events

AddEvent("LoadATMs", function()
	mariadb_async_query(sql, "SELECT * FROM atm;", OnAtmLoaded)
end)

AddRemoteEvent("iwb:OnClientDeposit", function (playerid, amount)

	if amount > GetPlayerCash(playerid) then
		return AddPlayerChatError(playerid, "You do not have enough money to deposit your chosen amount.")
	end

	RemovePlayerCash(playerid, amount)
	AddPlayerBankCash(playerid, amount)

	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Amount Deposited: $"..amount.."</>")
	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">New Balance: $".. GetPlayerBankCash(playerid) .."</>")
	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Thank you for using our services at the Imminent Wealth Bank, see you soon!</>")

	CallRemoteEvent(playerid, "iwb:OnServerATMAction", GetPlayerBankCash(playerid))
end)

AddRemoteEvent("iwb:OnClientWithdraw", function (playerid, amount)

	if amount > GetPlayerBankCash(playerid) then
		return AddPlayerChatError(playerid, "You do not have enough money to withdraw your chosen amount.")
	end

	AddPlayerCash(playerid, amount)
	RemovePlayerBankCash(playerid, amount)

	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Amount Withdrawn: $"..amount.."</>")
	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">New Balance: $".. GetPlayerBankCash(playerid) .."</>")
	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Thank you for using our services at the Imminent Wealth Bank, see you soon!</>")

	CallRemoteEvent(playerid, "iwb:OnServerATMAction", GetPlayerBankCash(playerid))
end)