function GetPlayerHelperRank()
    if PlayerData[player].helper == 0 then
        return 'Helper'
    elseif PlayerData[player].helper == 1 then
        return 'Head Helper'
    else
        return 'None'
    end
end