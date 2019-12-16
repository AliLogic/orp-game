local colour = ImportPackage('colours')

function ViewPlayerStats(player, target)
    target = tonumber(target)

    AddPlayerChat(player, string.format("<span color=\"%s\">|__________________%s [%s]__________________|</>", 
        colour.COLOUR_DARKGREEN(), GetPlayerName(target), PlayerData[target].name)) -- in future, add time.

    AddPlayerChat(player, string.format("<span color=\"%s\">CHARACTER: Gender:[%s] CharID:[%d]</>",
        colour.COLOUR_GRAD2(), (PlayerData[target].gender == 0 and 'Male' or 'Female'), PlayerData[player].id))

    AddPlayerChat(player, string.format("<span color=\"%s\">MONEY: Cash:[$%d] Bank:[$%d]</>", 
        colour.COLOUR_GRAD1(), PlayerData[target].cash, PlayerData[target].bank))

    if PlayerData[target].admin > 0 then
        AddPlayerChat(player, string.format("<span color=\"%s\">ADMIN: DBID:[%d] Dimension:[%d] Locale:[%s]</>",
            colour.COLOUR_LIGHTRED(), PlayerData[target].accountid, GetPlayerDimension(target), GetPlayerLocale(target)))

        AddPlayerChat(player, string.format("<span color=\"%s\">CONNECTION: IP:[%s]</>",
            colour.COLOUR_LIGHTRED(), GetPlayerIP(target)))
    end

    AddPlayerChat(player, string.format("<span color=\"%s\">|__________________%s [%s]__________________|</>", 
        colour.COLOUR_DARKGREEN(), GetPlayerName(target), PlayerData[target].name)) -- in future, add time.
end