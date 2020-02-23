-- Variables

FooterMsg = 0
FooterTimer = 0

-- Functions

function GetPlayerVehicleVelocity()

	local vehicle = GetPlayerVehicle()

	if vehicle == 0 then
		return 0
	end

	return math.tointeger(math.floor(GetVehicleVelocity(vehicle)))
end

function GetPlayerVehicleSpeed(kmh)

	local vehicle = GetPlayerVehicle()

	if vehicle == 0 then
		return 0
	end

	if kmh == true then
		return math.tointeger(math.floor(GetVehicleForwardSpeed(vehicle)))
	else
		return math.tointeger(math.floor(GetVehicleForwardSpeed(vehicle) / 1.609))
	end
end

function GetPlayerVehicleRPM()
	local vehicle = GetPlayerVehicle()

	if vehicle == 0 then
		return 0
	end

	return math.floor(GetVehicleEngineRPM(vehicle))
end

-- Events

AddRemoteEvent("PlayPlayerSound", function (sound)
	SetSoundVolume(CreateSound(sound), 2.0)
end)

AddRemoteEvent("ShowFooterMessage", function (message, color, seconds)

	if FooterMsg ~= 0 then
		DestroyTimer(FooterTimer)
		DestroyTextBox(FooterMsg)
		FooterMsg = 0
		FooterTimer = 0
	end

	message = "<span size=\"30\" color=\"".. color .."\" style=\"bold\">" .. message .. "</>"

	FooterMsg = CreateTextBox(0, 400, message, "center")
	SetTextBoxAnchors(FooterMsg, 0.5, 0.5, 0.5, 0.5)
	SetTextBoxAlignment(FooterMsg, 0.5, 0.5)

	FooterTimer = CreateTimer(function ()

		DestroyTimer(FooterTimer)
		DestroyTextBox(FooterMsg)
		FooterMsg = 0
		FooterTimer = 0
	end, seconds * 1000)
end)