local colour = ImportPackage('colours')

function GetPlayerAdminRank(player)

    local admin_level = tonumber(PlayerData[player].admin)

    if admin_level == 1 then
        return 'Administrator'
    elseif admin_level == 2 then
        return 'Senior Administrator'
    elseif admin_level == 3 then
        return 'Lead Administrator'
    elseif admin_level == 4 then
        return 'Developer'
    elseif admin_level == 5 then
        return 'Management'
    else
        return 'None'
    end
end

function SendAdminMessage(text)
    for _, i in pairs(GetAllPlayers()) do
		if PlayerData[i].admin > 0 then
            AddPlayerChat(i, text)
		end
	end
end