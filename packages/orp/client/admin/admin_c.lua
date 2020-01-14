local colour = ImportPackage('colours')
local borkui = ImportPackage('borkui')

local test = borkui.create(0)
borkui.addUITitle(test, 'Bork UI Test')
borkui.addUIDivider(test)
borkui.addTextInput()
borkui.addUIButton(test, 'Exit', 'is-danger')

--[[local Dialog = ImportPackage('dialogui')
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
end)]]

AddEvent("borkui:OnDialogSubmit", function (dialog, button, ...)
	AddPlayerChat('Dialog value: '..dialog)
	AddPlayerChat('Variable Value: '..test)
	AddPlayerChat('Button pressed: '..button)
	AddPlayerChat('Arguments: '..table.concat({...}, " "))
end)

AddRemoteEvent('borkui', function ()
	AddPlayerChat('(Client): Received event \'borkui\' from server.')
	AddPlayerChat('(Client): Value of test: '..test)
	borkui.show(test)
end)
