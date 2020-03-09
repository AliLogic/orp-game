-- Declarations

-- Functions

function Customization_Toggle(player, status)

	CallRemoteEvent(player, "Customization_Toggle", status)
end

function Customization_Ready(player)

	local gender = PlayerData[player].gender
	local shirts = 0
	local pants = 0
	local shoes = 0
	local hair = 0
	local face = 0

	if gender == 0 then -- Male
		shirts = 15
		pants = 5
		shoes = 3
		hair = 24
		face = 15
	else -- Female
		shirts = 14
		pants = 8
		shoes = 6
		hair = 3
		face = 3
	end


	CallRemoteEvent(player, "Customization_Ready", shirts, pants, shoes, hair, face)
end

-- Events

AddRemoteEvent("Customization_OnReady", function (player)

	Customization_Ready(player)
end)

AddRemoteEvent("Customization_OnSubmit", function (player)

	PlayerData[player].char_state = 2 -- Skipping the tutorial code for now

	Delay(100, function (player)
		SetPlayerIntro(player)
	end, player)
end)