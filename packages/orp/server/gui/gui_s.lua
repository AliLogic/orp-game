AddEvent("OnPlayerQuit", function (player)
	CallRemoteEvent(player, "DestroyGUI")
end)

function SetGUIHealth(player, health)
	if IsValidPlayer(player) ~= true then return false end
	if health < 0 then health = 0
	elseif health > 100 then health = 100 end

	CallRemoteEvent(player, "SetGUIHealth", health)
	return true
end

function SetGUIArmour(player, armour)
	if IsValidPlayer(player) ~= true then return false end
	if armour < 0 then armour = 0
	elseif armour > 100 then armour = 100 end

	CallRemoteEvent(player, "SetGUIArmour", armour)
	return true
end

function SetGUICash(player, money)
	if IsValidPlayer(player) ~= true then return false end
	if money < 0 then return false end

	CallRemoteEvent(player, "SetGUICash", money)
	return true
end

function SetGUIBank(player, money)
	if IsValidPlayer(player) ~= true then return false end
	if money < 0 then return false end

	CallRemoteEvent(player, "SetGUIBank", money)
	return true
end