function Mechanic_ShowCalls(playerid)

	local
		string = ""

	for _, i in pairs(GetAllPlayers()) do

		--if player has called mechanic then
		--	string = string .. "ID: " .. i .. " " .. GetPlayerName(i) .. " (".. GetPlayerLocation(i)
		--end
	end

	if #string == 0 then
		AddPlayerChat(playerid, "There are no mechanic calls to accept.");
	else
		-- show them a dialig with an option to select the "Mechanic Calls"
	end
end

AddCommand("acceptmechanic", function (playerid)

	if GetPlayerJob(playerid) ~= JOB_TYPE_MECHANIC then
		return AddPlayerChat(playerid, "You are not a mechanic.")
	end

	Mechanic_ShowCalls(playerid)
end)

AddCommand("repair", function (playerid)

	if GetPlayerJob(playerid) ~= JOB_TYPE_MECHANIC then
		return AddPlayerChat(playerid, "You are not a mechanic.")
	end

	if IsPlayerInVehicle(playerid) then
		return AddPlayerChat(playerid, "You must exit the vehicle first.")
	end

	--[[if not Inventory_HasItem(playerid, INV_ITEM_REPAIR) then
		return AddPlayerChat(playerid, "You don't have a repair kit on you.")
	end]]--

	local vehicle = GetNearestVehicle(playerid)
	local x, y, z = GetPlayerLocation(playerid)

	if not vehicle then
		AddPlayerChat(playerid, "You are not near any vehicle.")
	else
		-- If player is not near the hood then
		--	return AddPlayerChat(playerid, "You are not in range of any vehicle's hood.");
		-- end

		if not IsEngineVehicle(vehicle) then
			return AddPlayerChat(playerid, "This vehicle can't be repaired.")
		end

		if tonumber(math.floor(GetVehicleHoodRatio(vehicle))) == 0 then
			return AddPlayerChat(playerid, "The hood must be opened before a repair.")
		end

		if VehicleData[vehicle].being_repaired then
			return AddPlayerChat(playerid, "This vehicle is already being repaired.")
		end

		-- Inventory_Remove(playerid, "Repair Kit")
		SetPlayerAnimation(playerid, "COMBINE")
		VehicleData[vehicle].being_repaired = true
		AddPlayerChatRange(x, y, 800.0, "** "..GetPlayerName(playerid).." starts to repair the vehicle.")

		Delay(6000, function ()
			VehicleData[vehicle].being_repaired = false
			SetVehicleHealth(vehicle, 5000.0)
			AddPlayerChatRange(x, y, 800.0, "** "..GetPlayerName(playerid).." has successfully repaired the vehicle.")
		end)

		return
	end
end)

AddCommand("nitrous", function (playerid)

	if GetPlayerJob(playerid) ~= JOB_TYPE_MECHANIC then
		return AddPlayerChat(playerid, "You are not a mechanic.")
	end

	if IsPlayerInVehicle(playerid) then
		return AddPlayerChat(playerid, "You must exit the vehicle first.")
	end

	--[[if not Inventory_HasItem(playerid, INV_ITEM_NOS) then
		return AddPlayerChat(playerid, "You don't have a NOS Canister on you.")
	end]]--

	local vehicle = GetNearestVehicle(playerid)

	if not vehicle then
		AddPlayerChat(playerid, "You are not near any vehicle.")
	else
		if not IsVehicleCar(vehicle) then
			return AddPlayerChat(playerid, "This vehicle can't have nitrous.")
		end

		if tonumber(math.floor(GetVehicleHoodRatio(vehicle))) == 0 then
			return AddPlayerChat(playerid, "The hood must be opened before adding nitrous.")
		end

		-- Inventory_Remove(playerid, "NOS Canister")
		SetPlayerAnimation(playerid, "COMBINE")

		Delay(1000, function ()
			AttachVehicleNitro(vehicle, true)
			VehicleData[vehicle].nos = 1

			local x, y, z = GetPlayerLocation(playerid)
			AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." starts to repair the vehicle.")
		end)

		return
	end


	AddPlayerChat(playerid, "You are not in range of any vehicle's hood.");
end)