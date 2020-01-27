--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Raw
* Blue Mountains GmbH
]]--

--[[
	Usable Events:
	borkui:clientOnUICreated - returns playerid, dialogid and extraid.
	borkui:clientOnDialogSubmit - returns playerid, dialogid, extraid, button clicked and any arguments passed via JS.

	For any client side events, scan through borkui.js for any CallEvent's.
]]

AddRemoteEvent("borkui:clientOnUICreated", function (playerid, dialogid, extraid)
	AddPlayerChat(playerid, '(borkui): clientOnUICreated, with dialogid '..dialogid..' and extraid '..extraid..'.')
end)

AddRemoteEvent("borkui:clientOnDialogSubmit", function (playerid, dialogid, extraid, button, ...)
end)

function CreateUI(player, align, extraid)
	AddPlayerChat(player, '(borkui): Create UI, with align '..align..' and extraid '..extraid..'.')
	CallRemoteEvent(player, "borkui:serverCreateUI", align, true, extraid)
end

function AddUITitle(player, dialog, text)
	CallRemoteEvent(player, "borkui:serverAddUITitle", dialog, text)
end

function AddUIInformation(player, dialog, text)
	CallRemoteEvent(player, "borkui:serverAddUIInformation", dialog, text)
end

function AddUIDivider(player, dialog)
	CallRemoteEvent(player, "borkui:serverAddUIDivider", dialog)
end

function AddUIButton(player, dialog, text, colour, size, rounded, fullwidth, anchor)
	CallRemoteEvent(player, "borkui:serverAddUIButton", dialog, text, colour, size, rounded, fullwidth, anchor)
end

function AddUITextInput(player, dialog, label, size, type, placeholder)
	CallRemoteEvent(player, "borkui:serverAddUITextInput", dialog, label, size, type, placeholder)
end

function AddUIDropdown(player, dialog, options, size, rounded, label)
	CallRemoteEvent(player, "borkui:serverAddUIDropdown", dialog, options, size, rounded, label)
end

function ShowUI(player, dialog)
	CallRemoteEvent(player, "borkui:serverShowUI", dialog)
end

function HideUI(player)
	CallRemoteEvent(player, "borkui:serverHideUI")
end

function DestroyUI(player, dialog)
	CallRemoteEvent(player, "borkui:serverDestroyUI", dialog)
end

AddFunctionExport('createUI', CreateUI)
AddFunctionExport('addUITitle', AddUITitle)
AddFunctionExport('addUIInformation', AddUIInformation)
AddFunctionExport('addUIDivider', AddUIDivider)
AddFunctionExport('addUIButton', AddUIButton)
AddFunctionExport('addUITextInput', AddUITextInput)
AddFunctionExport('addUIDropdown', AddUIDropdown)
AddFunctionExport('showUI', ShowUI)
AddFunctionExport('hideUI', HideUI)
AddFunctionExport('destroyUI', DestroyUI)