AddCommand("pants", function (playerid, pantid)

	if pantid == nil then
		return AddPlayerChat(playerid, "/pants <1 - 6>")
	end

	pantid = tonumber(pantid)
	SetPlayerPropertyValue(playerid, "pant_id", pantid, true)

	CallRemoteEvent(playerid, "SetPlayerClothing", playerid)
end)

AddCommand("shirt", function (playerid, shirtid)

	if shirtid == nil then
		return AddPlayerChat(playerid, "/shoe <1 - 4>")
	end
	shirtid = tonumber(shirtid)

	SetPlayerPropertyValue(playerid, "shirt_id", shirtid, true)

	CallRemoteEvent(playerid, "SetPlayerClothing", playerid)
end)

AddCommand("shoe", function (playerid, shoeid)

	if shoeid == nil then
		return AddPlayerChat(playerid, "/shoe <1 - 4>")
	end
	shoeid = tonumber(shoeid)

	SetPlayerPropertyValue(playerid, "shoe_id", shoeid, true)

	CallRemoteEvent(playerid, "SetPlayerClothing", playerid)
end)

AddCommand("skin", function (playerid, r, g, b)

	if r == nil or g == nil or b == nil then
		return AddPlayerChat(playerid, "/skin <r> <g> <b>")
	end

	r = tonumber(r)
	g = tonumber(g)
	b = tonumber(b)

	SetPlayerPropertyValue(playerid, "skin_color_r", r, true)
	SetPlayerPropertyValue(playerid, "skin_color_g", g, true)
	SetPlayerPropertyValue(playerid, "skin_color_b", b, true)

	CallRemoteEvent(playerid, "SetPlayerClothing", playerid)
end)

AddCommand("pupil", function (playerid, pupil)

	if pupil == nil then
		return AddPlayerChat(playerid, "/pupil <size>")
	end

	pupil = tonumber(pupil)

	SetPlayerPropertyValue(playerid, "pupil_size", pupil, true)

	CallRemoteEvent(playerid, "SetPlayerClothing", playerid)
end)

AddEvent("OnPlayerJoin", function(playerid)

	SetPlayerPropertyValue(playerid, "pant_id", 2, true)
	SetPlayerPropertyValue(playerid, "shoe_id", 1, true)
	SetPlayerPropertyValue(playerid, "skin_color_r", 205, true)
	SetPlayerPropertyValue(playerid, "skin_color_g", 154, true)
	SetPlayerPropertyValue(playerid, "skin_color_b", 110, true)
	SetPlayerPropertyValue(playerid, "pupil_size", 1, true)
	SetPlayerPropertyValue(playerid, "shirt_id", 1, true)
	SetPlayerPropertyValue(playerid, "hair_id", 2, true)
	SetPlayerPropertyValue(playerid, "hair_color_r", 0, true)
	SetPlayerPropertyValue(playerid, "hair_color_g", 0, true)
	SetPlayerPropertyValue(playerid, "hair_color_b", 0, true)
	SetPlayerPropertyValue(playerid, "hair_color_a", 0, true)
	SetPlayerPropertyValue(playerid, "pant_color_r", 255, true)
	SetPlayerPropertyValue(playerid, "pant_color_g", 255, true)
	SetPlayerPropertyValue(playerid, "pant_color_b", 255, true)
	SetPlayerPropertyValue(playerid, "pant_color_a", 255, true)
end)

AddEvent("OnPlayerSpawn", function(playerid)
	CallRemoteEvent(playerid, "SetPlayerClothing", playerid)
end)