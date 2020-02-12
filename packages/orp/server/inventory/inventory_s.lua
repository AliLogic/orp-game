InventoryData = {}
MAX_INVENTORY_SLOTS = 12

-- Inventory Items with their ID's
INV_ITEM_RADIO = 1
INV_ITEM_REPAIR = 2
INV_ITEM_HEALTH = 3
INV_ITEM_TASER = 4
INV_ITEM_GPS = 5
INV_ITEM_BRICKPHONE = 6
INV_ITEM_SMARTPHONE = 7
INV_ITEM_NOSCAN = 8
INV_ITEM_WEED = 9
INV_ITEM_CIGAR = 10
INV_ITEM_CIGARETTE = 11
INV_ITEM_COCAINE = 12
INV_ITEM_HEROINE = 13
INV_ITEM_AMPHETAMINE = 14
INV_ITEM_XANAX = 15
INV_ITEM_PARACETAMOL = 16
INV_ITEM_STEROIDS = 17
INV_ITEM_FUELCAN = 18
INV_ITEM_MASK = 19
INV_ITEM_VEST = 20
INV_ITEM_WEEDSEED = 21
INV_ITEM_COKESEED = 22

ITEM_NAMES = {
	"Portable Radio",
	"Repair Kit",
	"Health Kit",
	"Taser",
	"GPS",
	"Brick Phone",
	"pearPhone I",
	"NOS Cannister",
	"Marijuana",
	"Cigar",
	"Cigarette",
	"Cocaine",
	"Heroine",
	"Amphetamine",
	"Xanax",
	"Paracetamol",
	"Steroids",
	"Fuel Can",
	"Mask",
	"Armored Vest",
	"Marijuana Seed",
	"Opium Poppy Seed"
}

--[[
	Functions from this module:

	Inventory_GiveItem(player, item, amount)
	Inventory_RemoveItem(player, slot)
	Inventory_HasItem(player, item)
	Inventory_GetItemName(item)
	Inventory_Clear(player)
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
	for i = 1, MAX_INVENTORY_SLOTS, 1 do
		CreatePlayerInventory(player, i)
	end

	local query = mariadb_prepare(sql, "SELECT * FROM inventory WHERE charid = ?;", PlayerData[player].id)
	mariadb_async_query(sql, query, OnInventoryLoaded, player)
end)

function OnInventoryLoaded(player)
	for i = 1, mariadb_get_row_count(), 1 do
		if i <= MAX_INVENTORY_SLOTS then
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

	InventoryData[player][slot] = {}
	InventoryData[player][slot].id = 0 -- attempt to index a nil value
	InventoryData[player][slot].itemid = 0
	InventoryData[player][slot].amount = 0
end

function Inventory_GiveItem(player, item, amount)
	if InventoryData[player] == nil then
		print("Inventory Data for Player IS NIL")
		return false
	end

	for i = 1, MAX_INVENTORY_SLOTS, 1 do
		if InventoryData[player][i].id == 0 and InventoryData[player][i].itemid == 0 and InventoryData[player][i].amount == 0 then
			print("Giving player "..GetPlayerName(player).." item id "..tonumber(item))

			InventoryData[player][i].itemid = item
			InventoryData[player][i].amount = amount

			local query = mariadb_prepare(sql, "INSERT INTO inventory (charid, itemid, amount) VALUES('?', '?', '?');",
				PlayerData[player].id,
				tonumber(item),
				amount
			)

			mariadb_async_query(sql, query, OnInventoryItemAdded, player, i)
			return true
		end
	end
	return false
end

function OnInventoryItemAdded(player, slot)
	print("Setting that item's SQL ID to "..mariadb_get_insert_id())
	InventoryData[player][slot].id = mariadb_get_insert_id()
end

function Inventory_RemoveItem(player, slot)
	if InventoryData[player][slot] == nil then return false end
	if InventoryData[player][slot].id == 0 then return false end

	InventoryData[player][slot] = nil
	CreatePlayerInventory(player, slot)

	local query = mariadb_prepare(sql, "DELETE FROM inventory WHERE id = ?;", InventoryData[player][slot].id)
	mariadb_async_query(sql, query)

end

function Inventory_HasItem(player, item)
	if InventoryData[player] == nil then return false end

	for i = 1, MAX_INVENTORY_SLOTS, 1 do
		if InventoryData[player][i].itemid == item then -- attempt to index a nil value
			return i
		end
	end

	return false
end

function Inventory_GetItemName(item)

	if item >= 1 and item <= #ITEM_NAMES then
		return ITEM_NAMES[item]
	end

	return "Item " .. item
end

function Inventory_Clear(playerid)

	for i = 1, MAX_INVENTORY_SLOTS, 1 do
		CreatePlayerInventory(playerid, i)
	end
end