local colour = ImportPackage('colours')

AtmObjectsCached = { }
ATMData = { }

local CONFIG_ATM_WITHDRAW_MIN = 1
local CONFIG_ATM_WITHDRAW_MAX = 2500

local CONFIG_ATM_DEPOSIT_MIN = 1
local CONFIG_ATM_DEPOSIT_MAX = 500

AddEvent("LoadATMs", function()
	mariadb_async_query(sql, "SELECT * FROM atm;", OnAtmLoaded)
end)

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

	print("Loaded "..#ATMData.." ATMs")
end

AddEvent("OnPlayerLoggedIn", function(player)
	CallRemoteEvent(player, "banking:atmsetup", AtmObjectsCached)
end)

function CreateATM(id, modelid, x, y, z, rx, ry, rz)
	ATMData[id] = { }
	ATMData[id].object = CreateObject(modelid, x, y, z, rx, ry, rz)		
	ATMData[id].text3d = CreateText3D("ATM\n/atm", 18, x, y, z + 200, 0, 0, 0)

	table.insert(AtmObjectsCached, ATMData[id].object)
end

AddRemoteEvent("banking:atminteract", function(player, atmobject)
	local atm = GetAtmByObject(atmobject)
	if atm then
		local x, y, z = GetObjectLocation(atm.object)
		local x2, y2, z2 = GetPlayerLocation(player)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 200 then
            CallRemoteEvent(player, "OpenATMMenu")
            
			--webgui.ShowInputBox(player, "Balance: "..FormatMoney(PlayerData[player].bank_balance).."<br><br>Withdraw money", "Withdraw", "OnBankingWithdrawMoney")
		end
	end
end)

function GetAtmByObject(atmobject)
	for _,v in pairs(ATMData) do
		if v.object == atmobject then
			return v
		end
	end
	return nil
end

AddRemoteEvent("banking:withdraw", function(player, amount)

	if amount > PlayerData[player].bank then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: You do not have enough money to withdraw your chosen amount.</>")
	end
	
    RemovePlayerCash(player, amount)

    AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Amount Withdrawn: $"..amount.."</>")
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">New Balance: $"..PlayerData[player].bank.."</>")
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Thank you for using our services at the Bank of Nevada, see you soon!</>")
end)

AddRemoteEvent("banking:deposit", function (player, amount)

	if amount > PlayerData[player].cash then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: You do not have enough money to deposit your chosen amount.</>")
	end

    AddPlayerCash(player, amount)

    AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Amount Deposited: $"..amount.."</>")
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">New Balance: $"..PlayerData[player].bank.."</>")
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Thank you for using our services at the Bank of Nevada, see you soon!</>")
end)

AddCommand("atm", function (player) 
    CallRemoteEvent(player, "OpenATMMenu", tonumber(PlayerData[player].bank))
end)