local colour = ImportPackage('colours')
local Dialog = ImportPackage('dialogui')
Dialog.setGlobalTheme("default-dark")

local confirmation = nil

local target = nil
local vehicle = nil

AddRemoteEvent("askClientActionConfirmation", function (responseid, message, targetid, vehicleid)
	if responseid == 1 then
		target = targetid
		vehicle = vehicleid

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

	CallRemoteEvent("clientActionConfirmationResult", button, GetPlayerId(), target, vehicle)

	target = nil
	vehicle = nil
end)