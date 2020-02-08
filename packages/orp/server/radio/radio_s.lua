local colour = ImportPackage('colours')

local function cmd_r(player, ...)
    if Inventory_HasItem(player, INV_ITEM_RADIO) == false then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You do not own a radio.") -- nil value?
    end

    if #{...} == 0 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(r)adio [text]")
    end

    if GetPlayerRadioChannel(player) == 0 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You are not tuned into any frequency.")
    end

    local text = table.concat({...}, " ")

    for _, i in pairs(GetAllPlayers()) do
        if GetPlayerRadioChannel(i) ~= false and GetPlayerRadioChannel(i) == GetPlayerRadioChannel(player) then
            AddPlayerChat(i, "<span color=\""..colour.COLOUR_RADIO().."\">** [CH: "..GetPlayerRadioChannel(player).."] "..GetPlayerName(i).." says:"..text.."</>")
            print("Player is: "..i)
        end
    end
end
AddCommand("radio", cmd_r)
AddCommand("r", cmd_r)

AddCommand("giveradio", function(player)
    if Inventory_HasItem(player, INV_ITEM_RADIO) then
        AddPlayerChat(player, "removed radio, confirm in /inventory.")
        Inventory_RemoveItem(player, Inventory_HasItem(player, INV_ITEM_RADIO))
    else
        AddPlayerChat(player, "giving radio, confirm in /inventory.")
        Inventory_GiveItem(player, INV_ITEM_RADIO, 0)
    end
end)

local function cmd_rtune(player, freq)
    if Inventory_HasItem(player, INV_ITEM_RADIO) == false then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You do not own a radio.")
    end

    if freq == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(r)adio(tune) <frequency>")
    end

    freq = tonumber(freq)

    if freq < 0 or freq > 9999 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Radio channels range from 0 - 9999.")
    end

    if freq == 911 and GetPlayerFactionType(player) ~= FACTION_POLICE then -- this does not execute atm, apparent nil value.
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> This frequency is reserved for a government agency.")
    end

    if freq == 991 and GetPlayerFactionType(player) ~= FACTION_MEDIC then -- this does not execute atm, apparent nil value.
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> This frequency is reserved for a government agency.")
    end

    if freq == 999 and GetPlayerFactionType(player) ~= FACTION_GOV then -- this does not execute atm, apparent nil value.
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> This frequency is reserved for a government agency.")
    end

    InventoryData[player][Inventory_HasItem(player, INV_ITEM_RADIO)].amount = freq

    local x, y, z = GetPlayerLocation(player)

    AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(player).." twists the dial on their radio, tuning it.</>")
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You have tuned your radio to "..freq..".</>")
end
AddCommand("radiotune", cmd_rtune)
AddCommand("rtune", cmd_rtune)

function GetPlayerRadioChannel(player)
    if Inventory_HasItem(player, INV_ITEM_RADIO) == false then
        return false
    end

    return InventoryData[player][Inventory_HasItem(player, INV_ITEM_RADIO)].amount
end