InventoryData = {}
MAX_SLOTS = 12

AddEvent("LoadInventory", function (player)
    local query = mariadb_prepare(sql, "SELECT * FROM `inventory` WHERE `charid` = ?;", PlayerData[player].id)
    mariadb_async_query(sql, query, OnInventoryLoaded, player)
end)

function OnInventoryLoaded(player)
    for i = 1, mariadb_get_row_count(), 1 do
        if i <= MAX_SLOTS then
            CreatePlayerInventory(player, i)
            local result = mariadb_get_assoc(i)

            InventoryData[player][i].itemid = result['itemid']
            InventoryData[player][i].amount = result['amount']
        end
    end
end

function CreatePlayerInventory(player, slot)
    if InventoryData[player] == nil then
        InventoryData[player] = {}
    end

    InventoryData[itemid][slot].itemid = 0
    InventoryData[itemid][slot].amount = 0
end