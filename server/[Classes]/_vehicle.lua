-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Reasoning behind duplicating it as a state and class table.
    - Just incase it goes arse up and state bags become fucked.
    - Preemuch the reason. So, Why rely on one, when you can have two?
]] --

math.randomseed(c.Seed)
-- ====================================================================================--
-- 
-- Too Add vehicle driving fuel consumption.

--[[


	`ID`
	`Character_ID`
	`Model` Hash
	`Plate` 8 Varchar
	`Coords` '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}'
	`Keys` json{} Character_ID's
	`Condition` vfuel, hp, other values
    `Inventory` json{}
    `Modifications` json{}handling info, mos and liverys
	`Garage` 2 character - A1 A2 A3
	`State` T/F In OUt
	`Impound` T/F In OUt
	`Wanted` T/F In OUt


]]--

---
function c.class.VehicleClass(networkid, owned, plate)
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
    -- If is not owned by a player on creation, do...
    if not owned then
        -- Declare
        local fuel = math.random(45,100)
        self.SetState('Plate', GetVehicleNumberPlateText(self.Entity))
        self.SetState('Coords', GetEntityCoords(self.Entity))
        self.SetState('Keys', {})
        self.SetState('Fuel', fuel)
        self.SetState('Model', GetEntityModel(self.Entity))
        self.SetState('Modifications', {})
        self.SetState('Condition', {})
        self.SetState('Inventory', {})
        self.SetState('Wanted', true)
        self.SetState('Instance', 0)
        -- Functions
        self.GetFuel = function()
            return self.GetState('Fuel')
        end
        --
        self.SetFuel = function(v)
            self.SetState('Fuel', v)
        end
        --
        self.AddFuel = function(num)
            local num = c.check.Number(num, 0, 100)
            self.SetFuel((self.GetFuel() + num))
            if self.GetFuel() >= 100 then
                self.SetFuel(100)
            end
        end
        --
        self.RemoveFuel = function(num)
            local num = c.check.Number(num, 0, 100)
            self.SetFuel((self.GetFuel() - num))
            if self.GetFuel() <= 0 then
                self.SetFuel(0)
            end
        end
        --
        self.GetCoords = function()
            local x,y,z = GetEntityCoords(self.Entity)
            local h = GetEntityHeading(self.Entity)
            return x,y,z,h
        end
        --
        self.SetCoords = function()
            local x,y,z,h = self.GetCoords()
            local Coords = {
                ['x'] = c.math.Decimals(x,2),
                ['y'] = c.math.Decimals(y,2),
                ['z'] = c.math.Decimals(z,2),
                ['h'] = c.math.Decimals(h,2)
            }
            self.SetState('Coords', Coords)
        end
        --
        self.GetInventory = function()
            return self.GetState('Inventory')
        end
        --
        self.SetInventory = function(t)
            self.Inventory = t
        end
        --
        -- If it IS owned by a player, DO...
    elseif owned then
        local data = c.sql.GetVehicleByPlate(plate)
        -- Declare
        self.Model = data.Model
        self.SetState('Model', self.Model)
        self.Plate = data.Plate
        self.SetState('Plate', self.Plate)
        self.Coords = json.decode(data.Coords)
        self.SetState('Coords', self.Coords)
        self.Keys = json.decode(data.Keys)
        self.SetState('Keys', self.Keys)
        self.Condition = json.decode(data.Condition)
        self.SetState('Condition', self.Condition)
        self.Inventory = json.decode(data.Inventory)
        self.SetState('Inventory', self.Inventory)
        self.Modifications = json.decode(data.Modifications)
        self.SetState('Modifications', self.Modifications)
        self.Instance = data.Instance
        self.SetState('Instance', self.Instance)
        self.Garage = data.Garage
        self.SetState('Garage', self.Garage)
        self.State = data.State
        self.SetState('State', self.State)
        self.Impound = data.Impound
        self.SetState('Impound', self.Impound)
        self.Wanted = data.Wanted
        self.SetState('Wanted', self.Wanted)
        -- Funcitons
        self.GetModifications = function()
            return self.Modifications
        end
        --
        self.SetModification = function(k,v)
            self.Modifications[k] = v
        end
        --
        self.SetModifications = function(t)
            self.Modifications = t
        end
        --
        self.GetCoords = function()
            local x,y,z = GetEntityCoords(self.Entity)
            local h = GetEntityHeading(self.Entity)
            return x,y,z,h
        end
        --
        self.SetCoords = function()
            local x,y,z,h = self.GetCoords()
            self.Coords = {
                ['x'] = c.math.Decimals(x,2),
                ['y'] = c.math.Decimals(y,2),
                ['z'] = c.math.Decimals(z,2),
                ['h'] = c.math.Decimals(h,2)
            }
            self.SetState('Coords', self.Coords)
        end
        --
        self.Fuel = self.Modifications.Fuel
        --
        self.GetFuel = function()
            return self.Fuel or self.GetState('Fuel')
        end
        --
        self.AddFuel = function(num)
            local num = c.check.Number(num, 0, 100)
            self.Fuel = (self.Fuel + num)
            self.SetState('Fuel', num)
            if self.Fuel >= 100 then
            self.Fuel = 100
            self.SetState('Fuel', 100)
            end
        end
        --
        self.RemoveFuel = function(num)
            local num = c.check.Number(num, 0, 100)
            self.Fuel = (self.Fuel - num)
            self.SetState('Fuel', num)
            if self.Fuel <= 0 then
            self.Fuel = 0
            self.SetState('Fuel', 0)
            end
        end
        --
        self.SetFuel = function(num)
            local num = c.check.Number(num, 0, 100)
            self.Fuel = num
            self.SetState('Fuel', num)
        end
        --
        
    end

    return self
end
