function GetPlayerAdminRank(player)

    AddPlayerChatAll("player: "..player..".")
    local admin_level = tonumber(PlayerData[player].admin)
    AddPlayerChatAll("admin_level: "..admin_level..".")

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