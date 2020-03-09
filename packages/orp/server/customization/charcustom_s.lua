-- Declarations

-- Functions

function Customization_Toggle(player, status)

	CallRemoteEvent(player, "Customization_Toggle", status)
end

function Customization_Ready(player)

	local gender = PlayerData[player].gender
	local shirts = {}
	local pants = {}
	local shoes = {}
	local hair = 0
	local face = 0

	if gender == 0 then -- Male
		shirts = {"Shirt 1", "Shirt 2"} -- 15
		pants = {"Pants 1", "Pants 2"} -- 5
		shoes = {"Shoes 1", "Shoes 2"} -- 3
		hair = 24
		face = 15
	else -- Female
		shirts = {"Shirt 1", "Shirt 2"} -- 14
		pants = {"Pants 1", "Pants 2"} -- 8
		shoes = {"Shoes 1", "Shoes 2"} -- 6
		hair = 3
		face = 3
	end


	CallRemoteEvent(player, "Customization_Ready", shirts, pants, shoes, hair, face)
end

-- Events

AddRemoteEvent("Customization_OnReady", function (player)

	Customization_Ready(player)
end)

-- AddRemoteEvent("Customization_OnSubmit", function (player, shirt, pant, shoe, skin, skin_tone, hair, hair_colour)
AddRemoteEvent("Customization_OnSubmit", function (player, shirt, pant, shoe, skin, hair)

	AddPlayerChat(player, "[server] Customization_OnSubmit")

	local gender = PlayerData[player].gender
	local colour = {}

	AddPlayerChat(player, "Shirt: " .. shirt + TOP_CONSTANTS[gender])
	AddPlayerChat(player, "Pant: " .. pant + PANTS_CONSTANTS[gender])
	AddPlayerChat(player, "Shoe: " .. shoe + SHOES_CONSTANTS[gender])
	AddPlayerChat(player, "Skin: " .. skin + BODY_CONSTANTS[gender])
	AddPlayerChat(player, "Hair: " .. hair + HAIR_CONSTANTS[gender])

	PlayerClothingData[player].hair = hair
	PlayerClothingData[player].pants = pant
	PlayerClothingData[player].top = shirt
	PlayerClothingData[player].shoes = shoe
	PlayerClothingData[player].body = skin

	SetPlayerClothing(player, player)

	PlayerData[player].char_state = 2 -- Skipping the tutorial code for now

	Delay(100, function (player)
		SetPlayerIntro(player)
	end, player)
end)