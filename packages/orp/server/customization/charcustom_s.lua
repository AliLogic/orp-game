-- Declarations

-- Functions

function Customization_Toggle(player, status)

	CallRemoteEvent(player, "Customization_Toggle", status)
end

function Customization_Ready(player)

	local gender = PlayerData[player].gender

	if gender == 0 then -- Male
		local shirts = 15
		local pants = 5
		local shoes = 3
		local hair = 24
		local face = 15
	else -- Female
		local shirts = 14
		local pants = 8
		local shoes = 6
		local hair = 3
		local face = 3
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