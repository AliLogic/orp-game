InventoryData = {}
MAX_SLOTS = 12

AddEvent("SaveInventory", function (player)
    for i = 1, #InventoryData[player], 1 do
        local query = mariadb_prepare(sql, "UPDATE inventory SET itemid = ?, amount = ? WHERE id = ?;",
            InventoryData[player][i].itemid,
            InventoryData[player][i].amount,
            InventoryData[player][i].id
        )
        mariadb_async_query(sql, query)
    end
end)

AddEvent("LoadInventory", function (player)
    local query = mariadb_prepare(sql, "SELECT * FROM inventory WHERE charid = ?;", PlayerData[player].id)
    mariadb_async_query(sql, query, OnInventoryLoaded, player)
end)

function OnInventoryLoaded(player)
    for i = 1, mariadb_get_row_count(), 1 do
        if i <= MAX_SLOTS then
            CreatePlayerInventory(player, i)

            InventoryData[player][i].id = mariadb_get_value_name_int(i, "id")
            InventoryData[player][i].itemid = mariadb_get_value_name_int(i, "itemid")
            InventoryData[player][i].amount = mariadb_get_value_name_int(i, "amount")
        end
    end
end

function CreatePlayerInventory(player, slot)
    if InventoryData[player] == nil then
        InventoryData[player] = {}
    end

    InventoryData[player][slot].id = 0
    InventoryData[player][slot].itemid = 0
    InventoryData[player][slot].amount = 0
end