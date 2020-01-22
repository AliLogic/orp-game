AddCommand("mine", function (playerid)

	if GetPlayerJob(playerid) ~= JOB_TYPE_MINER then
		return AddPlayerChat(playerid, "You are not a miner.")
	end

	if not IsPlayerNearJobPoint(playerid) then
		return AddPlayerChat(playerid, "You must be near a mine")
	end

	PlayerData[playerid].is_mining = (not PlayerData[playerid].is_mining)

	if (PlayerData[playerid].is_mining) then
		AddPlayerChat(playerid, "You are now mining! Use the fire key to begin digging.")
	else
		AddPlayerChat(playerid, "You have finished your mining job.")
	end
end)

AddRemoteEvent("OnPlayerMine", function (playerid)

	if (GetPlayerJob(playerid) == JOB_TYPE_MINER and PlayerData[playerid].is_mining) then
		local money = Random(5, 25)

		AddPlayerChat(playerid, "You have earned $"..money.." for the rock.");
		AddPlayerCash(playerid, money)
	end
end)