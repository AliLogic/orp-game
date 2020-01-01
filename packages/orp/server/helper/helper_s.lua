function GetPlayerHelperRank(player)

	local helper_level = tonumber(PlayerData[player].helper)

	if helper_level == 1 then
		return 'Helper'
	elseif helper_level == 2 then
		return 'Head Helper'
	else
		return 'None'
	end
end