AddCommand("pants", function (playerid, pantid)

	if pantid == nil then
		return AddPlayerChat(playerid, "/pants <1 - 6>")
	end

	pantid = tonumber(pantid)
	SetPlayerPropertyValue(playerid, "pant_id", pantid, true)
end)

AddCommand("shoe", function (playerid, shoeid)

	if shoeid == nil then
		return AddPlayerChat(playerid, "/shoe <1 - 4>")
	end
	local shoeid = tonumber(shoeid)

	SetPlayerPropertyValue(playerid, "shoe_id", shoeid, true)
end)

AddCommand("skin", function (playerid, r, g, b)

	if r == nil or g == nil or b == nil then
		return AddPlayerChat(playerid, "/skin <r> <g> <b>")
	end

	SetPlayerPropertyValue(playerid, "skin_color", r, g, b, true)
end)

AddCommand("pupil", function (playerid, pupil)

	if pupil == nil then
		return AddPlayerChat(playerid, "/pupil <size>")
	end

	SetPlayerPropertyValue(playerid, "pupil_size", pupil, true)
end)