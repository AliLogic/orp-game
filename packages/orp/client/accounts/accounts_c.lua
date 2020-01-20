local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("default-dark")

local charCreate = Dialog.create("New character:", "Create a new character", "Create", "Quit")
Dialog.setAutoclose(charCreate, false)
Dialog.addTextInput(charCreate, 1, "First Name:")
Dialog.addTextInput(charCreate, 1, "Last Name:")
Dialog.addSelect(charCreate, 1, "Gender:", 1, "Male", "Female")

local charViewNone = Dialog.create("Select character:", "Select a character to spawn as. If slot is empty, you will be prompted to create a new character.", "Select", "Quit")
Dialog.setAutoclose(charViewNone, false)
Dialog.addSelect(charViewNone, 1, "Select a character below:", 1, "(1) Create New Character", "(2) Create New Character", "(3) Create New Character")

local charview = nil
local creation_slot = 0

local charUI = CreateWebUI(0, 0, 0, 0, 1, 16)
SetWebAlignment(charUI, 0, 0)
SetWebAnchors(charUI, 0, 0, 1, 1)
SetWebURL(charUI, "http://asset/"..GetPackageName().."/client/charui/main.html")
SetWebVisibility(charUI, WEB_HIDDEN)

local charUIdata = {}
local count = 0

local is_frozen = false

AddEvent("OnWebLoadComplete", function(web)
	if web == charUI then
		--AddPlayerChat("WebUI now ready 1")
		--ExecuteWebJS(charUI, "toggleCharMenu();")
		--charUIready = true

		SetWebVisibility(charUI, WEB_VISIBLE)
		SetInputMode(charUI, INPUT_UI)
		ShowMouseCursor(true)

		if count ~= 0 then
			for i = 1, count, 1 do
				AddPlayerChat(charUIdata[i])
				ExecuteWebJS(charUI, "setCharacterInfo("..charUIdata[i]..");")
			end
		end

		ExecuteWebJS(charUI, "toggleCharMenu();")
	end
end)

AddEvent("OnPackageStop", function ()
	DestroyWebUI(charUI)
end)

AddRemoteEvent("askClientCreation", function ()
	Dialog.show(charCreate)
end)

AddRemoteEvent("askClientShowCharSelection", function(chardata, logout)

	SetIgnoreLookInput(true)
	SetIgnoreMoveInput(true)

	ShowHealthHUD(false)
	ShowWeaponHUD(false)

	SetCameraLocation(122371.22, 99170.25, 1668.49, true)
	SetCameraRotation(0, 265, 0, true)

	if chardata == nil then
		count = 0
		--ExecuteWebJS(charUI, "toggleCharMenu();")
		return
	end

	for _ in pairs(chardata) do count = count + 1 end

	if count ~= 0 then
		for i = 1, count, 1 do
			charUIdata[i] = "{slot:"..i..",firstname:'"..chardata[i].firstname.."',lastname:'"..chardata[i].lastname.."',level:"..chardata[i].level..",cash:"..chardata[i].cash.."}"
			--[[AddPlayerChat(string.format("setCharacterInfo({slot:%d,firstname:\"%s\",lastname:\"%s\",level:%d,cash:%d});",
			i, chardata[i].firstname, chardata[i].lastname, chardata[i].level, chardata[i].cash
			))
			ExecuteWebJS(charUI, "setCharacterInfo({slot:"..i..",firstname:"..chardata[i].firstname..",lastname:"..chardata[i].lastname..",level:"..chardata[i].level..",cash:"..chardata[i].cash.."});")]]
		end
	end

	if logout == true then
		charUI = CreateWebUI(0, 0, 0, 0, 1, 16)
		SetWebAlignment(charUI, 0, 0)
		SetWebAnchors(charUI, 0, 0, 1, 1)
		SetWebURL(charUI, "http://asset/"..GetPackageName().."/client/charui/main.html")
		SetWebVisibility(charUI, WEB_VISIBLE)
		SetInputMode(charUI, INPUT_UI)
		ShowMouseCursor(true)

		if count ~= 0 then
			for i = 1, count, 1 do
				ExecuteWebJS(charUI, "setCharacterInfo("..charUIdata[i]..");")
			end
		end

		ExecuteWebJS(charUI, "toggleCharMenu();")
	end

	--[[ExecuteWebJS(charUI, "test();")
	ExecuteWebJS(charUI, "toggleCharMenu();")]]

	--[[if count == 0 then
		AddPlayerChat("Count is 0")
		Dialog.show(charViewNone)
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
	end]]
end)

AddEvent("OnDialogSubmit", function(dialog, button, firstname, lastname, gender)
	if dialog == charCreate then
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

			if string.len(string.format("%s %s", firstname, lastname)) > 32 then
				return AddPlayerChat('Your firstname or lastname is too long.')
			end

			Dialog.close(charCreate)
			CallRemoteEvent("accounts:characterCreated", string.match(firstname, '[A-Z][a-z]*'), string.match(lastname, '[A-Z][a-z]*'), gender)

			SetCameraLocation(0, 0, 0, false)
			SetCameraRotation(0, 0, 0, false)

			ShowHealthHUD(true)
			ShowWeaponHUD(true)
		else
			Dialog.close(charCreate)
			CallRemoteEvent("accounts:kick")
		end
	elseif dialog == charViewNone then
		if button == 1 then
			creation_slot = 1
			Dialog.close(charViewNone)
			Dialog.show(charCreate)
		else
			Dialog.close(charViewNone)
			CallRemoteEvent("accounts:kick")
		end
	--[[elseif dialog == charview then
		if button == 1 then
			local slot = firstname

			if string.match(slot, "Create") then
				creation_slot = math.tointeger(string.match(slot, "%d"))
				Dialog.close(charview)
				Dialog.show(charCreate)
				return
			end

			AddPlayerChat('Logging in as '..string.match(slot, '[a-zA-Z]+ [a-zA-Z]+'))
			CallRemoteEvent("accounts:login", math.tointeger(string.match(slot, "%d")))
			Dialog.close(charview)
		else
			Dialog.close(charview)
			CallRemoteEvent("accounts:kick")
		end]]
	else
		return
	end
end)

--[[            ExecuteWebJS(web, "toggleCharMenu();");
			SetIgnoreLookInput(false)
			SetIgnoreMoveInput(false)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
			SetWebVisibility(web, WEB_HITINVISIBLE)
			]]

AddEvent('charui:create', function (slot)
	ExecuteWebJS(charUI, "toggleCharMenu();");
	SetIgnoreLookInput(false)
	SetIgnoreMoveInput(false)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	SetWebVisibility(charUI, WEB_HITINVISIBLE)

	creation_slot = math.tointeger(slot)
	Dialog.show(charCreate)
end)

AddEvent('charui:spawn', function (slot)
	ExecuteWebJS(charUI, "toggleCharMenu();");

	SetIgnoreLookInput(false)
	SetIgnoreMoveInput(false)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	SetWebVisibility(charUI, WEB_HIDDEN)
	DestroyWebUI(charUI)

	count = 0
	charUIdata = {}

	SetCameraLocation(0, 0, 0, false)
	SetCameraRotation(0, 0, 0, false)

	ShowHealthHUD(true)
	ShowWeaponHUD(true)

	CallRemoteEvent("accounts:login", math.tointeger(slot))
end)

AddEvent('charui:delete', function (slot)
	return AddPlayerChat('This functionality is disabled!')
end)

AddRemoteEvent('FreezePlayer', function ()
	if is_frozen == false then
		SetIgnoreMoveInput(false)
		SetIgnoreLookInput(false)
		is_frozen = true
	else
		SetIgnoreMoveInput(true)
		SetIgnoreLookInput(true)
		is_frozen = false
	end
	return true
end)