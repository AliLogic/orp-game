--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_
* Bork

Contributors:
* Blue Mountains GmbH
]]--

-- Variables
TruckerLevels = {
	{
		level = "Courier Trainee",
		hours = 0,
		vehicles = {22}
	},
	{
		level = "Courier",
		hours = 12,
		vehicles = {22}
	},
	{
		level = "Professional Courier",
		hours = 24,
		vehicles = {22, 24}
	},
	{
		level = "Trucker Trainee",
		hours = 32,
		vehicles = {22, 24}
	},
	{
		level = "Trucker",
		hours = 48,
		vehicles = {22, 24}
	},
	{
		level = "Professional Trucker",
		hours = 48,
		vehicles = {17, 22, 24}
	}
}

Vehicles = {
	{
		id = 17,
		slots = 32,
		cargo = {Cargo.crates, Cargo.brick_pallets, Cargo.loose}
	},
	{
		id = 22,
		slots = 12,
		cargo = {Cargo.crates}
	},
	{
		id = 24,
		slots = 18,
		cargo = {Cargo.crates, Cargo.brick_pallets}
	}
}

Cargo = {
	crates = {
		space = 1, -- 1 slot
		products = {
			Products.gunpowder, Products.steel_shapes, Products.clothes, Products.wood_planks, Products.beverages, Products.meal, Products.car_parts,
			Products.appliances, Products.fruits, Products.meat, Products.eggs
		}
	},
	brick_pallets = {
		space = 6, -- 6 slots
		products = {Products.brick_pallet}
	},
	liquids = {
		space = 1, -- 1 liquid metre^3.
		products = {Products.fuel, Products.milk, Products.dyes}
	},
	loose = {
		space = 1, -- 1 ton
		products = {Products.scrap_metal, Products.cotton, Products.cereal, Products.malt, Products.aggregate}
	}
}

Products = {
	gunpowder = {
		name = "gunpowder",
		id = 1
	},
	steel_shapes = {
		name = "steel shapes",
		id = 2
	},
	clothes = {
		name = "clothes",
		id = 3
	},
	wood_planks = {
		name = "wood planks",
		id = 4
	},
	beverages = {
		name = "beverages",
		id = 5
	},
	meal = {
		name = "meal",
		id = 6
	},
	car_parts = {
		name = "car parts",
		id = 7
	},
	appliances = {
		name = "appliances",
		id = 8
	},
	fruits = {
		name = "fruits",
		id = 9
	},
	meat = {
		name = "meat",
		id = 10
	},
	eggs = {
		name = "eggs",
		id = 11
	},
	brick_pallet = {
		name = "brick pallet",
		id = 12
	},
	fuel = {
		name = "fuel",
		id = 13
	},
	milk = {
		name = "milk",
		id = 14
	},
	dyes = {
		name = "dyes",
		id = 15
	},
	scrap_metal = {
		name = "scrap metal",
		id = 16
	},
	cotton = {
		name = "cotton",
		id = 17
	},
	cereal = {
		name = "cereal",
		id = 18
	},
	malt = {
		name = "malt",
		id = 19
	},
	aggregate = {
		name = "aggregate",
		id = 20
	}
}

-- Functions

function IsPlayerInTruck(player)
	if not IsPlayerInVehicle(player) then
		return false
	end

	local model = GetVehicleModel(GetPlayerVehicle(player))

	for i = 1, #Vehicles, 1 do
		if model == Vehicles[i].id then
			return true
		end
	end
	return false
end

-- Events