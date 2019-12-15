function GetPlayerAdminRank(player)
    if PlayerData[player].admin == 1 then
        return 'Administrator'
    elseif PlayerData[player].admin == 2 then
        return 'Senior Administrator'
    elseif PlayerData[player].admin == 3 then
        return 'Lead Administrator'
    elseif PlayerData[player].admin == 4 then
        return 'Developer'
    elseif PlayerData[player].admin == 5 then
        return 'Management'
    else
        return 'None'
    end
end