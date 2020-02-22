local colour = ImportPackage('colours')

AtmObjectsCached = { }
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

function OnAtmLoaded()
	for i = 1, mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)

		local id = math.tointeger(result["id"])
		local modelid = math.tointeger(result["modelid"])
		local x = tonumber(result["x"])
		local y = tonumber(result["y"])
		local z = tonumber(result["z"])
		local rx = tonumber(result["rx"])
		local ry = tonumber(result["ry"])
		local rz = tonumber(result["rz"])

		CreateATM(id, modelid, x, y, z, rx, ry, rz)
	end

	print("** ATMs Loaded: " .. #ATMData .. ".")
end

function CreateATM(id, modelid, x, y, z, rx, ry, rz)
	ATMData[id] = {}
	ATMData[id].text3d = CreateText3D("ATM\n/atm", 18, x, y, z + 200, 0, 0, 0)

	table.insert(AtmObjectsCached, ATMData[id].object)
end

function GetAtmByObject(atmobject)
	for _,v in pairs(ATMData) do
		if v.object == atmobject then
			return v
		end
	end
	return nil
end

-- Events

AddEvent("LoadATMs", function()
	mariadb_async_query(sql, "SELECT * FROM atm;", OnAtmLoaded)
end)

AddRemoteEvent("banking:atminteract", function(player, atmobject)
	local atm = GetAtmByObject(atmobject)
	if atm then
		local x, y, z = GetObjectLocation(atm.object)
		local x2, y2, z2 = GetPlayerLocation(player)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 200 then
            CallRemoteEvent(player, "iwb:opengui", GetPlayerCash(player), GetPlayerBankCash(player))
			--webgui.ShowInputBox(player, "Balance: "..FormatMoney(PlayerData[player].bank_balance).."<br><br>Withdraw money", "Withdraw", "OnBankingWithdrawMoney")
		end
	end
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

-- Commands
AddCommand("atm", function (player)
    CallRemoteEvent(player, "iwb:opengui", GetPlayerCash(player), GetPlayerBankCash(player))
end)