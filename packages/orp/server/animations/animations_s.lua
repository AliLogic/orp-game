--[[
    lay10 - /frontfall
    handsup_stand = /handsup
]]

AddCommand("anims", function (player)
	AddPlayerChat(player, "Animations: /sit /lay /wave /stretch /frontfall /handsup /(s)top(a)nim")
	return
end)

AddCommand("anim", function (playerid, anim)
	SetPlayerAnimation(playerid, anim)
end)

AddCommand("sit", function (playerid, sitid)
	if sitid == nil then
		return AddPlayerChat(playerid, "Usage: /sit <1-7>")
	end

	sitid = tonumber(sitid)

	if sitid < 1 or sitid > 7 then
		return AddPlayerChat(playerid, "Usage: /sit <1-7>")
	end

	SetPlayerAnimation(playerid, "SIT0"..sitid)
end)

AddCommand("lay", function (playerid, layid)
	if layid == nil then
		return AddPlayerChat(playerid, "Usage: /lay <1-18>")
	end

	layid = tonumber(layid)

	if layid < 1 or layid > 18 then
		return AddPlayerChat(playerid, "Usage: /lay <1-18>")
	end

	if layid < 10 then
		SetPlayerAnimation(playerid, "LAY0"..layid)
	else
		SetPlayerAnimation(playerid, "LAY"..layid)
	end
end)

AddCommand("wave", function (playerid, waveid)
	if waveid == nil then
		return AddPlayerChat(playerid, "Usage: /wave <1-2>")
	end

	waveid = tonumber(waveid)

	if waveid < 1 or waveid > 2 then
		return AddPlayerChat(playerid, "Usage: /wave <1-2>")
	end

	SetPlayerAnimation(playerid, "WAVE"..waveid)
end)

AddCommand("stretch", function (playerid)
	SetPlayerAnimation(playerid, "STRETCH")
end)

AddCommand("bow", function (playerid)
	SetPlayerAnimation(playerid, "BOW")
end)

AddComamnd("frontfall", function (player) 
	SetPlayerAnimation(player, "LAY10")
end)

AddCommand("handsup", function (player) 
	SetPlayerAnimation(player, "HANDSUP_STAND")
end)

function cmd_stopanim(player) 
	SetPlayerAnimation(player, "STOP")
end
AddCommand("stopanim", cmd_stopanim)
AddCommand("sa", cmd_stopanim)