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
	gunpowder = 1,
	steel_shapes = 2,
	clothes = 3,
	wood_planks = 4,
	beverages = 5,
	meal = 6,
	car_parts = 7,
	appliances = 8,
	fruits = 9,
	meat = 10,
	eggs = 11,
	brick_pallet = 12,
	fuel = 13,
	milk = 14,
	dyes = 15,
	scrap_metal = 15,
	cotton = 16,
	cereal = 17,
	malt = 18,
	aggregate = 19
}

-- Functions

-- Events