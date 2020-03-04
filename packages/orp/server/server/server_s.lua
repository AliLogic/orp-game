-- Variables

local ServerData = {}

-- Functions

local function OnLoadServerData()

	ServerData = {
		tax = 0,
		tax_percent = 10,
		double_xp = 0
	}

	if mariadb_get_row_count() ~= 0 then
		ServerData.tax = mariadb_get_value_name_float(1, "tax")
		ServerData.tax_percent = mariadb_get_value_name_float(1, "tax_percent")
		ServerData.double_xp = mariadb_get_value_name_float(1, "double_xp")
	end

	print("Tax: " .. ServerData.tax .. "")
	print("Tax Percent: " .. ServerData.tax_percent .. "")
	print("Double XP: " .. ServerData.double_xp .. "")
end

function Tax_AddMoney(amount)

	ServerData.tax = ServerData.tax + amount

end

function Tax_GetMoney(amount)

	return ServerData.tax

end

function Tax_Percent(price)

	return math.floor((price + 0.0) / 100) * ServerData.tax_percent;
end

function Server_IsDoubleXP()

	return ServerData.double_xp
end

function Server_SetDoubleXP(iEnable)

	ServerData.double_xp = iEnable
end

-- Events

AddEvent('LoadServer', function ()

	local query = mariadb_prepare(sql, "SELECT * FROM server")
	mariadb_query(sql, query, OnLoadServerData)
end)

AddEvent('UnloadServer', function ()

	local query = mariadb_prepare(sql, "UPDATE server SET tax = ?, tax_percent = ? WHERE server = 'server'")
	mariadb_query(sql, query)
end)