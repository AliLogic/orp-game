local colour = ImportPackage('colours')
local Dialog = ImportPackage('dialogui')
Dialog.setGlobalTheme("default-dark")

local confirmation = nil

local player = nil
local target = nil
local vehicle = nil

AddRemoteEvent("askClientActionConfirmation", function (player, id, message, ...)
    local args = {...}
    if id == 1 then
        gplayer = player
        target = args[2]
        vehicle = args[3]

        confirmation = Dialog.create("Are you sure?", message, "Yes", "No")
        Dialog.setAutoclose(confirmation, false)
        Dialog.show(confirmation)
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog ~= confirmation then
        return
    end

    Dialog.close(confirmation)
    confirmation = nil

    CallRemoteEvent("clientActionConfirmationResult", button, gplayer, target, vehicle)

    gplayer = nil
    target = nil
    vehicle = nil
end)