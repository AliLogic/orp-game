local colour = ImportPackage('colours')

local function cmd_acm(playerid, modelid)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if modelid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(m)arker <model>")
	end

	modelid = tonumber(modelid)

	if modelid < 334 or modelid > 337 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Model must be between 334 to 337.")
	end

	local x, y, z = GetPlayerLocation(playerid)

	local markerid = Marker_Create(modelid, x, y, z)
	if markerid == false then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Marker "..modelid.." wasn't able to be created!</>")
	else
		AddPlayerChat(playerid, string.format("<span color=\"%s\">Server: </>Marker %d (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), modelid, markerid))
	end
end

AddCommand("acreatemarker", cmd_acm)
AddCommand("acm", cmd_acm)

local function cmd_adm(playerid, markerid)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if markerid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ad)estroy(m)arker <marker>")
	end

	markerid = tonumber(markerid)

	if Marker_Destroy(markerid) == false then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Marker "..markerid.." wasn't able to be destroyed!</>")
	else
		AddPlayerChat(playerid, string.format("<span color=\"%s\">Server: </>Marker %d destroyed successfully!", colour.COLOUR_LIGHTRED(), markerid))
	end
end

AddCommand("adestroymarker", cmd_adm)
AddCommand("adm", cmd_adm)

local function cmd_aem(playerid, markerid, prefix, ...)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if markerid == nil or prefix == nil then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(m)arker <marker> <prefix>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> color, interior, exterior")
	end

	markerid = tonumber(markerid)

	if IsValidMarker(markerid) == false then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Marker "..markerid.." doesn't exist.")
	end

	if prefix == "color" then
		local r, g, b, a = {...}

		if r == nil or g == nil or b == nil or a == nil then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ad)estroy(m)arker <marker> <color> <red> <green> <blue> <alpha>")
		end

		if r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255 or a < 0 or a > 255 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The R, G, B, A values can only be between 0 to 255.")
		end

		MarkerData[markerid].r = r
		MarkerData[markerid].g = g
		MarkerData[markerid].b = b
		MarkerData[markerid].a = a

		SetPickupPropertyValue(MarkerData[markerid].pickup1, "r", tostring(r), false)
		SetPickupPropertyValue(MarkerData[markerid].pickup1, "g", tostring(g), false)
		SetPickupPropertyValue(MarkerData[markerid].pickup1, "b", tostring(b), false)
		SetPickupPropertyValue(MarkerData[markerid].pickup1, "a", tostring(a), false)

		if MarkerData[markerid].pickup2 ~= 0 then
			SetPickupPropertyValue(MarkerData[markerid].pickup2, "r", tostring(r), false)
			SetPickupPropertyValue(MarkerData[markerid].pickup2, "g", tostring(g), false)
			SetPickupPropertyValue(MarkerData[markerid].pickup2, "b", tostring(b), false)
			SetPickupPropertyValue(MarkerData[markerid].pickup2, "a", tostring(a), false)
		end

		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Marker "..markerid.." color changed.")
	elseif prefix == "interior" then
		local x, y, z = GetPlayerLocation(playerid)

		MarkerData[markerid].x1 = x
		MarkerData[markerid].y1 = y
		MarkerData[markerid].z1 = z

		--SetPickupLocation(MarkerData[markerid].pickup1, x, y, z)

		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Marker "..markerid.." interior location changed.")
	elseif prefix == "exterior" then
		local x, y, z = GetPlayerLocation(playerid)

		MarkerData[markerid].x2 = x
		MarkerData[markerid].y2 = y
		MarkerData[markerid].z2 = z

		if MarkerData[markerid].pickup2 ~= 0 then
			--SetPickupLocation(MarkerData[markerid].pickup2, x, y, z)
		end

		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Marker "..markerid.." exterior location changed.")
	else
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ad)estroy(m)arker <marker> <prefix>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> color, interior, exterior")
	end
end

AddCommand("aeditmarker", cmd_aem)
AddCommand("aem", cmd_aem)