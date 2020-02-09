--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Raw
* Blue Mountains GmbH
]]--

local web = 0
local nextId = 1
local dialogs = {}
local lastOpened = 0

local COLUMN_TYPE_DIVIDER = 1
local COLUMN_TYPE_BUTTON = 2
local COLUMN_TYPE_TEXTINPUT = 3
local COLUMN_TYPE_DROPDOWN = 4

AddEvent("OnPackageStart", function()
	web = CreateWebUI(0, 0, 0, 0, 1, 16)
	SetWebAlignment(web, 0, 0)
	SetWebAnchors(web, 0, 0, 1, 1)
	SetWebURL(web, "http://asset/"..GetPackageName().."/borkui.html")
	SetWebVisibility(web, WEB_HIDDEN)
end)

AddEvent("OnPackageStop", function()
	DestroyWebUI(web)
end)

function CreateUI(align, source, extraid)
	align = align or 0
	source = source or false
	extraid = extraid or 0

	if align < 0 or align > 2 then
		align = 0
	end

	local id = nextId
	nextId = nextId + 1

	dialogs[id] = {
		extraid = extraid,
		title = '',
		columns = {}
	}

	if source then
		CallRemoteEvent("borkui:clientOnUICreated", id, extraid)
	end

	AddPlayerChat('(borkui): UI created, with align '..align..' and id '..id..' and extraid '..extraid..'.')
	return id
end
AddRemoteEvent('borkui:serverCreateUI', CreateUI)

function AddUITitle(id, text)
	if dialogs[id] == nil then
		AddPlayerChat('dialog is invalid')
		return false
	end

	if string.len(text) < 1 then
		AddPlayerChat('string length of text is below 1')
		return false
	end
	dialogs[id].title = text
	AddPlayerChat('(borkui): AddUITitle called')
end
AddRemoteEvent('borkui:serverAddUITitle', AddUITitle)

function AddUIInformation(id, text)
	if dialogs[id] == nil then
		return false
	end

	if string.len(text) < 1 then
		return false
	end

	dialogs[id].info = text
	AddPlayerChat('(borkui): AddUIInformation called')
end
AddRemoteEvent('borkui:serverAddUIInformation', AddUIInformation)

function AddUIDivider(id)
	if dialogs[id] == nil then
		return false
	end

	table.insert(dialogs[id].columns, {COLUMN_TYPE_DIVIDER})
	AddPlayerChat('(borkui): AddUIDivider called')
end
AddRemoteEvent('borkui:serverAddUIDivider', AddUIDivider)

function AddUIButton(id, text, colour, size, rounded, fullwidth, anchor)
	if dialogs[id] == nil then
		return false
	end

	colour = colour or 'is-dark'
	size = size or 1
	rounded = rounded or false
	fullwidth = fullwidth or true
	anchor = anchor or 0

	if anchor < 0 or anchor > 2 then
		anchor = 0
	end

	if size < 0 or size > 3 then
		size = 1
	end

	table.insert(dialogs[id].columns, {COLUMN_TYPE_BUTTON, text, colour, size, rounded, fullwidth, anchor})
	AddPlayerChat('(borkui): AddUIButton called')
end
AddRemoteEvent('borkui:serverAddUIButton', AddUIButton)

function AddUITextInput(id, label, size, type, placeholder)
	if dialogs[id] == nil then
		return false
	end

	label = label or 'Default'
	size = size or 1
	type = type or 0
	placeholder = placeholder or ''

	if string.len(label) < 1 then
		label = 'Default'
	end

	if size < 0 or size > 3 then
		size = 1
	end

	if type < 0 or type > 1 then
		type = 0
	end

	table.insert(dialogs[id].columns, {COLUMN_TYPE_TEXTINPUT, label, size, type, placeholder})
	AddPlayerChat('(borkui): AddUITextInput called')
end
AddRemoteEvent('borkui:serverAddUITextInput', AddUITextInput)

function AddUIDropdown(id, options, size, rounded, label)
	if dialogs[id] == nil then
		return false
	end

	size = size or 1
	rounded = rounded or false
	label = label or ''

	if size < 0 or size > 3 then
		size = 1
	end

	local jsonoptions = '['

	for i = 1, #options, 1 do
		if i == #options then
			jsonoptions = jsonoptions.."'"..options[i].."'"
		else
			jsonoptions = jsonoptions.."'"..options[i].."'"..','
		end
	end

	jsonoptions = jsonoptions..']'

	table.insert(dialogs[id].columns, {COLUMN_TYPE_DROPDOWN, jsonoptions, size, rounded, label})
	AddPlayerChat('(borkui): AddUIDropdown called')
end
AddRemoteEvent('borkui:serverAddUIDropdown', AddUIDropdown)

function ShowUI(id)
	if dialogs[id] == nil then
		return false
	end

	if dialogs[id].title == '' then
		return false
	end

	if #dialogs[id].columns < 1 then
		return false
	end

	if lastOpened ~= 0 then
		HideUI()
	end

	local column

	AddPlayerChat('(borkui): TITLE SHOULD BE \''..dialogs[id].title..'\'.')
	ExecuteWebJS(web, "addTitle('"..dialogs[id].title.."');")

	ExecuteWebJS(web, "addInformation('"..dialogs[id].info.."');")

	for i = 1, #dialogs[id].columns, 1 do
		column = dialogs[id].columns[i]

		if dialogs[id].columns[i][1] == COLUMN_TYPE_DIVIDER then
			ExecuteWebJS(web, 'addDivider();')
		elseif dialogs[id].columns[i][1] == COLUMN_TYPE_BUTTON then
			ExecuteWebJS(web, string.format('addButton("%s", "%s", %d, %s, %s, %d);', column[2], column[3], column[4], tostring(column[5]), tostring(column[6]), column[7]))
		elseif dialogs[id].columns[i][1] == COLUMN_TYPE_TEXTINPUT then
			ExecuteWebJS(web, string.format('addTextInput("%s", %d, %d, "%s");', column[2], column[3], column[4], column[5]))
		elseif dialogs[id].columns[i][1] == COLUMN_TYPE_DROPDOWN then
			ExecuteWebJS(web, string.format('addDropdown(%s, %d, %s, "%s");', column[2], column[3], tostring(column[4]), column[5]))
		end
	end

	SetWebVisibility(web, WEB_VISIBLE)
	ExecuteWebJS(web, 'showUI('..id..');')
	SetIgnoreLookInput(true)
	SetIgnoreMoveInput(true)
	ShowMouseCursor(true)
	SetInputMode(INPUT_GAMEANDUI)

	lastOpened = id
	AddPlayerChat('(borkui): ShowUI called')
end
AddRemoteEvent('borkui:serverShowUI', ShowUI)

function HideUI()
	AddPlayerChat("HideUI client side called")
	if dialogs[lastOpened] == nil then
		return false
	end

	ExecuteWebJS('hideUI();')
	lastOpened = 0
	SetIgnoreLookInput(false)
	SetIgnoreMoveInput(false)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	SetWebVisibility(web, WEB_HITINVISIBLE)

	AddPlayerChat('(borkui): HideUI call finished')
end
AddRemoteEvent('borkui:serverHideUI', HideUI)

function DestroyUI(id)
	if lastOpened == id then
		HideUI()
	end
	dialogs[id] = nil
	AddPlayerChat('(borkui): DestroyUI called')
end
AddRemoteEvent('borkui:serverDestroyUI', DestroyUI)

AddEvent("borkui:ready", function()
	if lastOpened ~= -1 then
		ShowUI(lastOpened)
		AddPlayerChat('(borkui): borkui is ready (ready received)!')
	end
end)

AddEvent("borkui:OnHideMenu", function()
	if lastOpened ~= -1 then
		Delay(1, function()
			SetIgnoreLookInput(true)
			SetIgnoreMoveInput(true)
			ShowMouseCursor(true)
			SetInputMode(INPUT_GAMEANDUI)

			AddPlayerChat('(borkui): OnHideMenu received.')
		end)
	end
end)

AddEvent("borkui:OnDialogSubmit", function (dialog, button, ...)
	dialog = math.tointeger(dialog)
	button = math.tointeger(button)

	AddPlayerChat('(borkui): UI submitted, with dialog '..dialog..', extraid '..dialogs[dialog].extraid..', button '..button..' and text '.. ... ..'.')
	CallRemoteEvent("borkui:clientOnDialogSubmit", dialog, dialogs[dialog].extraid, button, table.concat({...}, " "))
end)

--[[
	CreateUI
	AddUITitle
	AddUIInformation
	AddUIDivider
	AddUIButton
	AddUITextInput
	AddUIDropdown
	ShowUI
	HideUI
	DestroyUI
]]

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