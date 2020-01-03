--[[
    lay10 - /frontfall
    handsup_stand = /handsup
]]

AddCommand("anims", function (player)
	AddPlayerChat(player, "Animations: /sit /lay /wave /stretch /clap /frontfall /handsup /lean /yawn /bow /drunk /(s)top(a)nim")
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
		return AddPlayerChat(playerid, "Usage: /wave <1-3>")
	end

	waveid = tonumber(waveid)

	if waveid < 1 or waveid > 3 then
		return AddPlayerChat(playerid, "Usage: /wave <1-3>")
	end

	if waveid == 1 then
		SetPlayerAnimation(playerid, "WAVE")
	else
		SetPlayerAnimation(playerid, "WAVE"..waveid)
	end
end)

AddCommand("lean", function (playerid, leanid)
	if leanid == nil then
		return AddPlayerChat(playerid, "Usage: /lean <1-4>")
	end

	leanid = tonumber(leanid)

	if leanid < 1 or leanid > 4 then
		return AddPlayerChat(playerid, "Usage: /clap <1-4>")
	end

	SetPlayerAnimation(playerid, "WALLLEAN0"..leanid)
end)

AddCommand("clap", function (playerid, clapid)
	if clapid == nil then
		return AddPlayerChat(playerid, "Usage: /clap <1-3>")
	end

	clapid = tonumber(clapid)

	if clapid < 1 or clapid > 3 then
		return AddPlayerChat(playerid, "Usage: /clap <1-3>")
	end

	if clapid == 1 then
		SetPlayerAnimation(playerid, "CLAP")
	else
		SetPlayerAnimation(playerid, "CLAP"..clapid)
	end
end)

AddCommand("stretch", function (playerid)
	SetPlayerAnimation(playerid, "STRETCH")
end)

AddCommand("bow", function (playerid)
	SetPlayerAnimation(playerid, "BOW")
end)

AddCommand("frontfall", function (player)
	SetPlayerAnimation(player, "LAY10")
end)

AddCommand("handsup", function (player)
	SetPlayerAnimation(player, "HANDSUP_STAND")
end)

AddCommand("drunk", function (player)
	SetPlayerAnimation(player, "DRUNK")
end)

AddCommand("yawn", function (player)
	SetPlayerAnimation(player, "YAWN")
end)

local function cmd_stopanim(player)
	SetPlayerAnimation(player, "STOP")
end
AddCommand("stopanim", cmd_stopanim)
AddCommand("sa", cmd_stopanim)