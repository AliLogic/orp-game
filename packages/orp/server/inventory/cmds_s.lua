local colour = ImportPackage('colours')

function cmd_inv(player)
    if InventoryData[player] == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You have nothing in your inventory!")
    end

    if #InventoryData[player] == 0 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You have nothing in your inventory!")
    end

    AddPlayerChat(player, string.format("<span color=\"%s\">|_________[%s's Inventory]_________|</>",
        colour.COLOUR_DARKGREEN(), GetPlayerName(player)
    ))

    for i = 1, MAX_INVENTORY_SLOTS, 1 do
        AddPlayerChat(player, string.format("<span color=\"%s\">(Slot: %d)</> %s [Amount: %d]",
            colour.COLOUR_DARKGREEN(),
            i,
            Inventory_GetItemName(InventoryData[player][i].itemid),
            InventoryData[player][i].amount
        ))
    end
end
AddCommand("inventory", cmd_inv)
AddCommand("inv", cmd_inv)