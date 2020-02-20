local colour = ImportPackage("colours")

local function cmd_buy(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0
	local biz = Business_Nearest(playerid)

	if biz == 0 then
		return AddPlayerChat(playerid, "You are not near any business.")
	end

	if BusinessData[biz].enterable == 1 then
		distance = GetDistance3D(x, y, z, BusinessData[biz].mx, BusinessData[biz].my, BusinessData[biz].mz)
	end

	if distance <= 200.0 then

		AddPlayerChat(playerid, "You are near the business ID: "..biz..". Show them the purchase menu!")
		return
	end
end

local function cmd_biz(playerid, prefix, ...)

	local biz = Business_Nearest(playerid)

	if prefix ~= nil and biz == 0 then
		return AddPlayerChatError(playerid, "You are not near any businesses.")
	end

	if prefix == "lock" or prefix == "unlock" then

		if #BusinessData[biz].doors == 0 then

			if BusinessData[biz].locked == 1 then
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">unlocked</> the business.")
				BusinessData[biz].locked = 0
			else
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">locked</> the business.")
				BusinessData[biz].locked = 1
			end
		else
			local doorid = BusinessData[biz].doors[1]

			if DoorData[doorid].is_locked == 1 then
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">unlocked</> the business door.")
				DoorData[doorid].is_locked = 0
			else
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">locked</> the business door.")
				SetDoorOpen(DoorData[doorid].door, false)
				DoorData[doorid].is_locked = 1
			end
		end

		SetPlayerAnimation(playerid, "LOCKDOOR")

	elseif prefix == "shop" then

		cmd_buy(playerid)

	elseif prefix == "buy" then

		if BusinessData[biz].owner == 0 and BusinessData[biz].ownership_type == BUSINESS_OWNERSHIP_SOLE then

			if BusinessData[biz].price > GetPlayerCash(playerid) then
				AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You have insufficient funds to purchase this property.")
			end

			RemovePlayerCash(playerid, BusinessData[biz].price)
			BusinessData[biz].owner = PlayerData[playerid].id

			AddPlayerChat(playerid, "You have successfully purchased the business ("..biz..") for <span color=\""..colour.COLOUR_DARKGREEN().."\">$"..BusinessData[biz].price.."</>.")
		else
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This business can not be purchased.</>")
		end

	elseif prefix == "sell" then

		if BusinessData[biz].owner == PlayerData[playerid].id then

			local price = math.floor(BusinessData[biz].price / 2)

			AddPlayerCash(playerid, price)
			BusinessData[biz].owner = 0

			AddPlayerChat(playerid, "You have successfully sold the business ("..biz..") for <span color=\""..colour.COLOUR_DARKGREEN().."\">$"..price.."</>.")
		else
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You do not own this business.")
		end

	elseif prefix == "kickdoor" then

		if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">You are not in the appropriate faction to execute this command.</>")
		end

		if BusinessData[biz].locked == 0 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This business is already unlocked.</>")
		end

		local x, y, z = GetPlayerLocation(playerid)
		AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." attempts to kick the business's door down.")

		if #BusinessData[biz].doors == 0 then
			Delay(2000, function ()

				if Business_Nearest(playerid) ~= biz then
					return
				end

				SetPlayerAnimation(playerid, "KICKDOOR")

				if Random(0, 6) <= 2 then
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">failed</> to kick the door down.")
					AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." has failed to kick the door down.")
				else
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">succeeded</> to kick the door down.")
					AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." has successfully kicked the door down.")

					BusinessData[biz].locked = 0
				end
			end)
		else
			local doorid = BusinessData[biz].doors[1]

			if DoorData[doorid].is_locked == 0 then
				return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This business is already unlocked.</>")
			end

			AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." attempts to kick the business's door down.")

			Delay(2000, function ()

				if Business_Nearest(playerid) ~= biz then
					return
				end

				SetPlayerAnimation(playerid, "KICKDOOR")

				if Random(0, 6) <= 2 then
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">failed</> to kick the door down.")
					AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." has failed to kick the door down.")
				else
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">succeeded</> to kick the door down.")
					AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." has successfully kicked the door down.")

					DoorData[doorid].is_locked = 0
					SetDoorOpen(DoorData[doorid].door, true)
				end
			end)
		end

	else
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /biz <prefix>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> (un)lock, buy, sell, shop")
	end
end

AddCommand("biz", cmd_biz)

local function cmd_acb(player, biztype, enterable, price, ...)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if biztype == nil or enterable == nil or price == nil or #{...} == 0 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(b)usiness <type> <enterable> <price> <name>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Types: Entrance (1), Local (2), Ammunation (3), Bar (4)")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Types: Restaurant (5), Bank (6)")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Enterable: No (0), Yes (1)")
		return 
	end

	biztype = tonumber(biztype)
	enterable = tonumber(enterable)
	price = tonumber(price)
	local name = table.concat({...}, " ")

	if biztype < 1 or type > BUSINESS_TYPE_MAX then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Types range from 1 to "..BUSINESS_TYPE_MAX.."</>")
	end

	if enterable < 0 or enterable > 1 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The enter states can be either 0 or 1.</>")
	end

	if price < 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The business cannot be cheaper than $0!</>")
	end

	local length = string.length(name)

	if length < 0 or length > 32 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Name length ranges from 1 to 32 characters.</>")
	end

	local business = Business_Create(player, biztype, enterable, price, name)

	if business == false then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Business ID "..business.." wasn't able to be created!</>")
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
		return AddPlayerChatError(player, "You don't have permission to use this command.")
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

AddCommand("gotobiz", function (playerid, bizid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "ou don't have permission to use this command.")
	end

	if bizid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotobiz <biz>")
	end

	bizid = tonumber(bizid)

	if BusinessData[bizid] == nil then
		return AddPlayerChatError(playerid, "Business " .. bizid .. "doesn't exist.")
	end

	SetPlayerLocation(playerid, BusinessData[bizid].ex, BusinessData[bizid].ey, BusinessData[bizid].ez)

	AddPlayerChat(playerid, "You have been teleported to business ID: " .. bizid ..".")
end)