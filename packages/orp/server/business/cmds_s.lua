local colour = ImportPackage("colours")

AddCommand("buy", function(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for _, v in pairs(BusinessData) do

		if BusinessData[v] ~= nil then
			if BusinessData[v].enterable == 1 then
				distance = GetDistance3D(x, y, z, BusinessData[v].mx, BusinessData[v].my, BusinessData[v].mz)
			end

			if distance <= 200.0 then

				AddPlayerChat(playerid, "You are near the business ID: "..v..".")
				return
			end
		end
	end

	return AddPlayerChat(playerid, "You are not near any business.")
end)

local function cmd_acb(player, biztype, enterable, price, ...)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if biztype == nil or enterable == nil or price == nil or #{...} == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage: </>/(ac)reate(b)usiness <type> <enterable> <price> <name>")
	end

	biztype = tonumber(biztype)
	enterable = tonumber(enterable)
	price = tonumber(price)
	local name = table.concat({...}, " ")

	if biztype < 1 or biztype > BUSINESS_TYPE_MAX then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: </>")
	end

	if enterable < 0 or enterable > 1 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The enter states can be either 0 or 1.</>")
	end

	if price < 0 or price > 10000000 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The business price must be between 0 to $10,000,000.</>")
	end

	local length = string.length(name)

	if length < 0 or length > 32 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The business name must be between X to Y.</>")
	end

	local x, y, z = GetPlayerLocation(player)

	local business = Business_Create(player, biztype, enterable, price, name)
	if business == false then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Business wasn't able to be created.</>")
	else
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Business (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), business))
	end
	return
end
AddCommand("acreatebusiness", cmd_acb)
AddCommand("acreatebiz", cmd_acb)
AddCommand("acb", cmd_acb)

local function cmd_aeb(player, business, prefix, ...)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if business == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage: </>/(ae)dit(b)usiness <business> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> type, marker")
	end

	business = tonumber(business)

	if BusinessData[business] == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Business "..business.." doesn't exist or isn't valid.</>")
	end

	local args = {...}

	if prefix == "type" then

		local biztype = args[1]

		if biztype == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(b)usiness <business> type <type>")
		end

		biztype = tonumber(biztype)

		if biztype < 1 or biztype > BUSINESS_TYPE_MAX then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: </>")
		end

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Business (ID: "..business..") type is now set to "..BusinessTypes[biztype].." from "..BusinessTypes[BusinessData[business].type]..".</>")
		BusinessData[business].type = biztype

	elseif prefix == "marker" then
	end

	return
end

AddCommand("aeditbusiness", cmd_aeb)
AddCommand("aeditbiz", cmd_aeb)
AddCommand("aeb", cmd_aeb)