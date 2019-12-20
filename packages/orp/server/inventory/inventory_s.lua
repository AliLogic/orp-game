InventoryData = {}
MAX_INVENTORY_SLOTS = 12

-- Inventory Items with their ID's
INV_ITEM_RADIO = 1

--[[
    Functions from this module:

    Inventory_GiveItem(player, item, amount)
    Inventory_RemoveItem(player, slot)
    Inventory_HasItem(player, item)
    Inventory_GetItemName(item)
]]--

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
        if i <= MAX_INVENTORY_SLOTS then
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

function Inventory_GiveItem(player, item, amount)
    if InventoryData[player] == nil then return false end

    for i = 1, MAX_INVENTORY_SLOTS, 1 do
        if InventoryData[player][i].id == 0 and InventoryData[player][i].itemid == 0 and nventoryData[player][i].amount == 0 then
            local query = mariadb_prepare(sql, "INSERT INTO inventory (charid, itemid, amount) VALUES('?', '?', '?');",
                PlayerData[player].id,
                item,
                amount
            )

            mariadb_async_query(sql, query, OnInventoryItemAdded, player, i)
            return true
        end
    end
    return false
end

function OnInventoryItemAdded(player, slot)
    InventoryData[player][slot].id = mariadb_get_insert_id()
end

function Inventory_RemoveItem(player, slot)
    if InventoryData[player][slot] == nil or InventoryData[player][slot].id == 0 then return false end

    InventoryData[player][slot] = nil
    CreatePlayerInventory(player, slot)

    local query = mariadb_prepare(sql, "DELETE FROM inventory WHERE id = ?;", InventoryData[player][slot].id)
    mariadb_async_query(sql, query)

end

function Inventory_HasItem(player, item)
    if InventoryData[player] == nil then return false end

    for i = 1, MAX_INVENTORY_SLOTS, 1 do
        if InventoryData[player][i].itemid == item then
            return i
        end
    end

    return false
end

function Inventory_GetItemName(item)
    if item < INV_ITEM_RADIO or item > INV_ITEM_RADIO then return false end

    if item == INV_ITEM_RADIO then
        return 'Radio'
    end
end