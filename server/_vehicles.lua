--[[


	`ID`
	`Character_ID`
	`Model` Hash
	`Plate` 8 Varchar
	`Position` '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}'
	`Keys` json{} Character_ID's
	`Condition` vfuel, hp, other values
    `Inventory` json{}
    `Modifications` json{}handling info, mos and liverys
	`Garage` 2 character - A1 A2 A3
	`State` T/F In OUt
	`Impound` T/F In OUt
	`Wanted` T/F In OUt


]]--

c.vehicle = {} -- function level
c.vehicles = {} -- data to save


