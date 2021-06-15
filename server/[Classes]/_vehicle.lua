-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - 
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

-- Too Add vehicle driving fuel consumption.

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

function c.class.VehicleClass(networkid, plate)
    local data = c.sql.GetVehicleByPlate(plate)
    local self = {}
    self.Entity = NetworkGetEntityFromNetworkId(networkid)
    --
    EnsureEntityStateBag(self.Entity)
    --
    self.SetState = function(k,v)
        Entity(self.Entity).state[k] = v
    end
    --
    self.GetState = function(k)
        return Entity(self.Entity).state[k]
    end
    --
    self.Model = data.Model
    self.Plate = data.Plate
    self.SetState(Plate, self.Plate)
    self.Coords = json.decode(data.Position)
    self.SetState(Coords, self.Coords)
    self.Keys = json.decode(data.Keys)
    self.SetState(Keys, self.Keys)
    self.Condition = json.decode(data.Condition)
    self.Inventory = json.decode(data.Inventory)
    self.Modifications = json.decode(data.Modifications)
    self.Instance = data.Instance
    self.Garage = data.Garage
    self.State = data.State
    self.Impound = data.Impound
    self.Wanted = data.Wanted
    --
    self.GetPosition = function()
        local x,y,z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        return x,y,z,h
    end
    --
    self.SetPosition = function()
        local x,y,z,h = self.GetPosition()
        self.Coords = {
            ['x'] = c.math.Decimals(x,2),
            ['y'] = c.math.Decimals(y,2),
            ['z'] = c.math.Decimals(z,2),
            ['h'] = c.math.Decimals(h,2)
        }
        self.SetState(Coords, self.Coords)
        return self.Coords
    end
    --
    self.Fuel = self.Condition.Fuel
    self.SetState(Fuel, self.Condition.Fuel)
    --
    self.GetFuel = function()
        return self.Fuel or self.GetState(Fuel)
    end
    --
    self.AddFuel = function(num)
        local num = c.check.Number(num, 0, 100)
        self.Fuel = (self.Fuel + num)
        self.SetState(Fuel, num)
        if self.Fuel >= 100 then
           self.Fuel = 100
           self.SetState(Fuel, 100)
        end
    end
    --
    self.RemoveFuel = function(num)
        local num = c.check.Number(num, 0, 100)
        self.Fuel = (self.Fuel - num)
        self.SetState(Fuel, num)
        if self.Fuel <= 0 then
           self.Fuel = 0
           self.SetState(Fuel, 0)
        end
    end
    --
    self.SetFuel = function(num)
        local num = c.check.Number(num, 0, 100)
        self.Fuel = num
        self.SetState(Fuel, num)
    end
    --
    return self
end
