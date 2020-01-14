local web = CreateWebUI(0, 0, 0, 0, 1, 16)
SetWebAlignment(web, 0, 0)
SetWebAnchors(web, 0, 0, 1, 1)
SetWebURL(web, "http://asset/"..GetPackageName().."/borkui.html")
SetWebVisibility(web, WEB_HITINVISIBLE)

local nextId = 1
local dialogs = {}
local lastOpened = 0

local COLUMN_TYPE_DIVIDER = 1
local COLUMN_TYPE_BUTTON = 2
local COLUMN_TYPE_TEXTINPUT = 3
local COLUMN_TYPE_DROPDOWN = 4

AddEvent("OnPackageStop", function()
	DestroyWebUI(web)
end)

function CreateUI(align)
	align = align or 0

	if align < 0 or align > 2 then
		align = 0
	end

	local id = nextId
	nextId = nextId + 1

	dialogs[id] = {
		title = '',
		columns = {}
	}

	AddPlayerChat('(borkui): UI created, with align '..align..' and id '..id)
	return id
end

function AddUITitle(id, text)
	if dialogs[id] == nil then
		return false
	end

	if string.len(text) < 1 then
		return false
	end
	dialogs[id].title = text
	AddPlayerChat('(borkui): AddUITitle called')
end

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

function AddUIDivider(id)
	if dialogs[id] == nil then
		return false
	end

	table.insert(dialogs[id].columns, {COLUMN_TYPE_DIVIDER})
	AddPlayerChat('(borkui): AddUIDivider called')
end

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
		HideUI(lastOpened)
	end

	local column

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

function HideUI()
	if dialogs[lastOpened] == nil then
		return false
	end

	lastOpened = 0
	ExecuteWebJS('clearUI();')
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
	SetWebVisibility(web, WEB_HITINVISIBLE)

	AddPlayerChat('(borkui): HideUI called')
end

function DestroyUI(id)
    if lastOpened == id then
        closeDialog()
    end
	dialogs[id] = nil
	AddPlayerChat('(borkui): DestroyUI called')
end

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

AddFunctionExport('create', CreateUI)
AddFunctionExport('addUITitle', AddUITitle)
AddFunctionExport('addUIInformation', AddUIInformation)
AddFunctionExport('addUIDivider', AddUIDivider)
AddFunctionExport('addUIButton', AddUIButton)
AddFunctionExport('addUITextInput', AddUITextInput)
AddFunctionExport('addUIDropdown', AddUIDropdown)
AddFunctionExport('show', ShowUI)
AddFunctionExport('hide', HideUI)
AddFunctionExport('destroy', DestroyUI)