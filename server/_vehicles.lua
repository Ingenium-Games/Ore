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

function c.vehicle.GetVehicle(plate)
    return c.vehicles[plate]
end

--- Same as above.
---@param plate string
function c.GetVehicle(plate)
    return c.vehicle.GetVehicle(plate)
end

function c.vehicle.SetVehicle(plate, data)
    c.vehicles[plate] = data
end

function c.vehicle.RemoveVehicle(plate)
    c.vehicles[plate] = false
end

function c.vehicle.GetVehicles()
    return c.vehicles
end

function c.GetVehicles()
    return c.vehicle.GetVehicles()
end


