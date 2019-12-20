local colour = ImportPackage('colours')
local Dialog = ImportPackage('dialogui')

local StreamedAtmIds = { }
local AtmIds = { }

local CONFIG_ATM_WITHDRAW_MIN = 1
local CONFIG_ATM_WITHDRAW_MAX = 2500

local CONFIG_ATM_DEPOSIT_MIN = 1
local CONFIG_ATM_DEPOSIT_MAX = 500

local atmmenu = nil
local withdrawmenu = nil
local depositmenu = nil

AddRemoteEvent("banking:atmsetup", function(AtmObjects)
	AtmIds = AtmObjects

	-- Reset the table
	StreamedAtmIds = { }

	for _,v in pairs(AtmIds) do
		-- IsValidObject returns true on the client if this object is streamed in
		if IsValidObject(v) then
			table.insert(StreamedAtmIds, v)
		end
	end
end)

AddEvent("OnObjectStreamIn", function(object)
	for _,v in pairs(AtmIds) do
		if object == v then
			table.insert(StreamedAtmIds, v)
			break
		end
	end
end)

AddEvent("OnObjectStreamOut", function(object)
	for _,v in pairs(AtmIds) do
		if object == v then
			table.remove(StreamedAtmIds, tablefind(StreamedAtmIds, v))
			break
		end
	end
end)

AddRemoteEvent("OpenATMMenu", function (bal)
    if GetNearestATM() ~= 0 then
        atmmenu = Dialog.create("ATM Interaction:", 
            string.format("Welcome to the Bank of Nevada!<br><br>Your current balance is %d.<br><br>Please select a menu to continue:", bal),
            "Withdraw", "Deposit", "Exit"
        )
        Dialog.show(atmmenu)

        AddPlayerChat("atm should show")
        
    else
        return AddPlayerChat("<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You are not near any ATMs!")
    end     
end)

AddEvent("OnDialogSubmit", function (dialog, button, amount)
    if dialog == atmmenu then
        if button == 1 then
            local player = GetPlayerId()

            if PlayerData[player].bank < 1 then
                Dialog.close(atmmenu)
                atmmenu = nil

                return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: You have no money to withdraw!</>")
            end

            Dialog.close(atmmenu)
            atmmenu = nil

            withdrawmenu = Dialog.create("ATM Interaction:",
                "Welcome to the Bank of Nevada.<br><br>Please enter in a amount to withdraw<br>The maximum you can withdraw at a time is "..CONFIG_ATM_WITHDRAW_MAX..":",
                "Withdraw", "Exit"
            )
            Dialog.addTextInput(withdrawmenu, 1, "Amount:")
            Dialog.show(withdrawmenu)
        elseif button == 2 then
            local player = GetPlayerId()

            if PlayerData[player].cash < 1 then
                Dialog.close(atmmenu)
                atmmenu = nil

                return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: You have no money to deposit!</>")
            end

            Dialog.close(atmmenu)
            atmmenu = nil

            depositmenu = Dialog.create("ATM Interaction:",
                "Welcome to the Bank of Nevada.<br><br>Please enter in a amount to withdraw:",
                "Withdraw", "Exit"
            )
            Dialog.addTextInput(depositmenu, 1, "Amount:")
            Dialog.show(depositmenu)
        else
            Dialog.close(atmmenu)
            atmmenu = nil
            return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Thank you for using our services at the Bank of Nevada, see you soon!</>")
        end

    elseif dialog == withdrawmenu then
        if button == 1 then
            if amount == nil then return end

            amount = math.tointeger(amount)
        
            if amount < CONFIG_ATM_WITHDRAW_MIN or amount > CONFIG_ATM_WITHDRAW_MAX then
                return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Your withdrawal amount is either too little or too much. Please retry.</>")
            end

            if amount > PlayerData[player].bank then
                return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: You do not have enough money to withdraw your chosen amount.</>")
            end

            Dialog.close(withdrawmenu)
            withdrawmenu = nil

            CallRemoteEvent("banking:withdraw", amount)
        else
            Dialog.close(withdrawmenu)
            withdrawmenu = nil
            return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Thank you for using our services at the Bank of Nevada, see you soon!</>")
        end


    elseif dialog == depositmenu then
        if button == 1 then
            if amount == nil then return end

            amount = math.tointeger(amount)
        
            if amount < CONFIG_ATM_DEPOSIT_MIN or amount > CONFIG_ATM_DEPOSIT_MAX then
                return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Your deposit amount is either too little or too much. Please retry.</>")
            end

            if amount > PlayerData[player].cash then
                return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: You do not have enough money to deposit your chosen amount.</>")
            end

            Dialog.close(depositmenu)
            depositmenu = nil

            CallRemoteEvent("banking:deposit", amount)
        else
            Dialog.close(depositmenu)
            depositmenu = nil
            return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">ATM: Thank you for using our services at the Bank of Nevada, see you soon!</>")
        end
    else
        return
    end
end)

function OnBankingWithdrawMoney(value)
	CallRemoteEvent("banking:withdraw", math.tointeger(value))
end
AddEvent("OnBankingWithdrawMoney", OnBankingWithdrawMoney)

function GetNearestATM()
	local x, y, z = GetPlayerLocation()

	for _,v in pairs(StreamedAtmIds) do
		local x2, y2, z2 = GetObjectLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 160.0 then
			return v
		end
	end

	return 0
end

function tablefind(tab, el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
end