AddCommand("pants", function (playerid, pantid)

	if pantid == nil then
		return AddPlayerChat(playerid, "/pants <1 - 6>")
	end

	pantid = tonumber(pantid)
	CallRemoteEvent(playerid, "SetPlayerPants", pantid)
end)

AddCommand("shoe", function (playerid, shoeid)

	if shoeid == nil then
		return AddPlayerChat(playerid, "/shoe <1 - 4>")
	end
	local shoeid = tonumber(shoeid)

	CallRemoteEvent(playerid, "SetPlayerShoes", shoeid)
end)

AddCommand("skin", function (playerid, r, g, b)

	if r == nil or g == nil or b == nil then
		return AddPlayerChat(playerid, "/skin <r> <g> <b>")
	end

	CallRemoteEvent(playerid, "SetPlayerSkinColor", r, g, b)
end)

AddCommand("pupil", function (playerid, pupil)

	if pupil == nil then
		return AddPlayerChat(playerid, "/pupil <size>")
	end

	CallRemoteEvent(playerid, "SetPlayerPupilSize", pupil)
end)