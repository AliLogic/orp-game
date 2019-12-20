local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("default-dark")

local charcreate = Dialog.create("New character:", "Create a new character", "Create", "Quit")
Dialog.setAutoclose(charcreate, false)
Dialog.addTextInput(charcreate, 1, "First Name:")
Dialog.addTextInput(charcreate, 1, "Last Name:")
Dialog.addSelect(charcreate, 1, "Gender:", 1, "Male", "Female")

local charviewnone = Dialog.create("Select character:", "Select a character to spawn as. If slot is empty, you will be prompted to create a new character.", "Select", "Quit")
Dialog.setAutoclose(charviewnone, false)
Dialog.addSelect(charviewnone, 1, "Select a character below:", 1, "(1) Create New Character", "(2) Create New Character", "(3) Create New Character")

local charview = nil
local creation_slot = 0

AddRemoteEvent("askClientCreation", function ()
    Dialog.show(charcreate)
end)

AddRemoteEvent("askClientShowCharSelection", function(chardata)
    if chardata == nil then
        return Dialog.show(charviewnone)
    end

    local count = 0
    for _ in pairs(chardata) do count = count + 1 end
    
    if count == 0 then
        AddPlayerChat("Count is 0")
        Dialog.show(charviewnone)
    else
        local char = {}
        char[1] = 'Create New Character'
        char[2] = 'Create New Character'
        char[3] = 'Create New Character'

        for i = 1, count, 1 do
            char[i] = chardata[i].firstname.." "..chardata[i].lastname
        end

        charview = Dialog.create("Select character:", "Select a character to spawn as. If slot is empty, you will be prompted to create a new character.", "Select", "Quit")
        Dialog.setAutoclose(charview, false)
        Dialog.addSelect(charview, 1, "Select a character below:", 1, "(1) "..char[1], "(2) "..char[2], "(3) "..char[3])
        Dialog.show(charview)
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button, firstname, lastname, gender)
    if dialog == charcreate then
        if button == 1 then
            if string.len(firstname) < 1 then
                return AddPlayerChat('You must enter in a username!')
            end
    
            if string.len(lastname) < 1 then
                return AddPlayerChat('You must enter in a lastname!')
            end
    
            if string.match(firstname, "Create") or string.match(lastname, "Create") then
                return AddPlayerChat('Blacklisted word in your first or lastname, please verify you\'ve entered in a valid name.')
            end
                
            if string.match(firstname, '[A-Z][a-z]*') == nil or string.match(lastname, '[A-Z][a-z]*') == nil then
                return AddPlayerChat('Your Firstname and Lastname must begin with a capital letter, followed by lowercase letter (Example: John, Doe).')
            end
    
            Dialog.close(charcreate)
            CallRemoteEvent("accounts:characterCreated", string.match(firstname, '[A-Z][a-z]*'), string.match(lastname, '[A-Z][a-z]*'), gender)
        else
            Dialog.close(charcreate)
            CallRemoteEvent("accounts:kick")
        end
    elseif dialog == charviewnone then
        if button == 1 then
            creation_slot = 1
            Dialog.close(charviewnone)
            Dialog.show(charcreate)
        else
            Dialog.close(charviewnone)
            CallRemoteEvent("accounts:kick")
        end
    elseif dialog == charview then
        if button == 1 then
            local slot = firstname

            if string.match(slot, "Create") then
                creation_slot = math.tointeger(string.match(slot, "%d"))
                Dialog.close(charview)
                Dialog.show(charcreate)
                return
            end

            AddPlayerChat('Logging in as '..string.match(slot, '[a-zA-Z]+ [a-zA-Z]+'))
            CallRemoteEvent("accounts:login", math.tointeger(string.match(slot, "%d")))
            Dialog.close(charview)
        else
            Dialog.close(charview)
            CallRemoteEvent("accounts:kick")
        end
    else
        return
    end
end)

AddRemoteEvent('FreezePlayer', function (player)
    if PlayerData[player].is_frozen == false then
        SetIgnoreMoveInput(false)
        SetIgnoreLookInput(false)
        PlayerData[player].is_frozen = true
    else
        SetIgnoreMoveInput(true)
        SetIgnoreLookInput(true)
        PlayerData[player].is_frozen = false
    end
    return true
end)
