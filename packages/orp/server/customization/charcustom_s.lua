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

AddRemoteEvent("Customization_OnSubmit", function (player, shirt, pant, shoe, skin, skin_tone, hair, hair_colour)

	local gender = PlayerData[player].gender
	local colour = {}

	AddPlayerChat(player, "Shirt: " .. shirt + TOP_CONSTANTS[gender])
	AddPlayerChat(player, "Pant: " .. pant + PANTS_CONSTANTS[gender])
	AddPlayerChat(player, "Shoe: " .. shoe + SHOES_CONSTANTS[gender])
	AddPlayerChat(player, "Skin: " .. skin + BODY_CONSTANTS[gender])
	AddPlayerChat(player, "Skin tone: " .. skin_tone)
	AddPlayerChat(player, "Hair: " .. hair + HAIR_CONSTANTS[gender])
	AddPlayerChat(player, "Hair colour: " .. hair_colour)

	skin_tone = skin_tone .. ","
	for i in string:gmatch("(%d+),") do
		table.insert(colour, i)
	end
	PlayerClothingData[player].hair_color = RGB(colour[1], colour[2], colour[3])

	colour = {}
	hair_colour = hair_colour .. ","
	for i in string:gmatch("(%d+),") do
		table.insert(colour, i)
	end
	PlayerClothingData[player].skin_color = RGB(colour[1], colour[2], colour[3])

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