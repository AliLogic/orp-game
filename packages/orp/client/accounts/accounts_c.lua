--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("default-dark")

local charCreate = Dialog.create("New character:", "Create a new character", "Create", "Quit")
Dialog.setAutoclose(charCreate, false)
Dialog.addTextInput(charCreate, 1, "First Name:")
Dialog.addTextInput(charCreate, 1, "Last Name:")
Dialog.addSelect(charCreate, 1, "Gender:", 1, "Male", "Female")

local charUI = 0
local charUIdata = {}
local count = 0
local is_frozen = false

-- Functions

local function UpdateCharactersList()

	if count ~= 0 then
		for i = 1, count, 1 do
			ExecuteWebJS(charUI, "setCharacterInfo("..charUIdata[i]..");")
		end
	end

	ExecuteWebJS(charUI, "toggleCharMenu();")
end

local function ToggleCharUI(status)

	SetIgnoreLookInput(status)
	SetIgnoreMoveInput(status)

	ShowHealthHUD(not status)
	ShowWeaponHUD(not status)

	ShowMouseCursor(status)

	if status == false then
		SetCameraLocation(0, 0, 0, false)
		SetCameraRotation(0, 0, 0, false)

		SetInputMode(INPUT_GAME)
	else
		SetCameraLocation(122371.22, 99170.25, 1668.49, true)
		SetCameraRotation(0, 265, 0, true)

		SetInputMode(INPUT_UI)
	end
end

-- Events

AddEvent("OnPackageStart", function()
	charUI = CreateWebUI(0, 0, 0, 0, 1, 16)
	SetWebAlignment(charUI, 0, 0)
	SetWebAnchors(charUI, 0, 0, 1, 1)
	SetWebURL(charUI, "http://asset/"..GetPackageName().."/client/charui/main.html")
	SetWebVisibility(charUI, WEB_HIDDEN)
end)

AddEvent("OnWebLoadComplete", function(web)
	if web == charUI then
		SetWebVisibility(charUI, WEB_VISIBLE)
		SetInputMode(charUI, INPUT_UI)
		ShowMouseCursor(true)

		UpdateCharactersList()
	end
end)

AddEvent("OnPackageStop", function ()
	DestroyWebUI(charUI)
end)

AddRemoteEvent("askClientCreation", function ()
	Dialog.show(charCreate)
end)

AddRemoteEvent("askClientShowCharSelection", function(chardata, logout)

	ToggleCharUI(true)

	if chardata == nil then
		count = 0
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

	if logout == true and count ~= 0 then
		charUI = CreateWebUI(0, 0, 0, 0, 1, 16)
		SetWebAlignment(charUI, 0, 0)
		SetWebAnchors(charUI, 0, 0, 1, 1)
		SetWebURL(charUI, "http://asset/"..GetPackageName().."/client/charui/main.html")
		SetWebVisibility(charUI, WEB_VISIBLE)

		UpdateCharactersList()
		ExecuteWebJS(charUI, "toggleCharMenu();")
	end
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

			ToggleCharUI(false)
		else
			Dialog.close(charCreate)
			CallRemoteEvent("accounts:kick")
		end
	else
		return
	end
end)

AddEvent('charui:create', function (slot)

	ToggleCharUI(false)
	ExecuteWebJS(charUI, "toggleCharMenu();");
	SetWebVisibility(charUI, WEB_HITINVISIBLE)

	Dialog.show(charCreate)
end)

AddEvent('charui:spawn', function (slot)

	ToggleCharUI(false)
	ExecuteWebJS(charUI, "toggleCharMenu();");
	SetWebVisibility(charUI, WEB_HIDDEN)
	DestroyWebUI(charUI)

	count = 0
	charUIdata = {}

	CallRemoteEvent("accounts:login", math.tointeger(slot))
end)

AddEvent('charui:delete', function (slot)
	return AddPlayerChat('This functionality is disabled!')
end)

AddRemoteEvent('FreezePlayer', function (status)
	if status == true then
		SetIgnoreMoveInput(true)
		SetIgnoreLookInput(true)
		GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body"):SetEnableGravity(false)
		is_frozen = true
	else
		SetIgnoreMoveInput(false)
		SetIgnoreLookInput(false)
		GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body"):SetEnableGravity(true)
		is_frozen = false
	end
	return true
end)

AddRemoteEvent("SetPlayerGenderVoice", function (is_male)
	SetPlayerVoiceTone(GetPlayerId(), is_male)
end)

AddRemoteEvent("SetPlayerCameraLocation", function (x, y, z, a, status)
	SetCameraLocation(x, y, z, status)
	SetCameraRotation(0, a, 0, status)
	SetIgnoreLookInput(status)
end)

AddEvent("OnRenderHUD", function()
	local FlyingState, TopRotorSpeed, ForwardRate, UpRate, StrafeRate, TurnRate, UpSpeed, ForwardSpeed, RightSpeed, TurnSpeed, RollSpeed, PitchSpeed, YawSpeed = GetHeliDebugInfo(GetPlayerVehicle())

	if FlyingState ~= false then
		DrawText(4, 300, "State: "..FlyingState..", Rotor Speed: "..TopRotorSpeed)
		DrawText(4, 320, "FR: "..ForwardRate..", UR: "..UpRate..", SR: "..StrafeRate..", TR: "..TurnRate)
		DrawText(4, 340, "US: "..math.floor(UpSpeed)..", FW: "..math.floor(ForwardSpeed)..", RS: "..math.floor(RightSpeed)..", TS: "..TurnSpeed)
		DrawText(4, 360, "RS: "..math.floor(RollSpeed)..", PS: "..math.floor(PitchSpeed)..", YS: "..YawSpeed)
	end
end)