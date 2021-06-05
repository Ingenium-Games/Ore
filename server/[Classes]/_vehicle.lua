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

function c.class.VehicleClass(entity)
    local _min = 0
    local _max = 100
    local self = {}
    --
    self.Fuel = math.random(73, 100)
    --
    self.GetFuel = function()
        return self.Fuel
    end
    --
    self.AddFuel = function(num)
        local num = c.check.Number(num, _min, _max)
        self.Fuel = (self.Fuel + num)
        if self.Fuel >= 100 then
           self.Fuel = 100
        end
    end
    --
    self.RemoveFuel = function(num)
        local num = c.check.Number(num, _min, _max)
        self.Fuel = (self.Fuel - num)
        if self.Fuel <= 0 then
           self.Fuel = 0
        end
    end
    --
    self.SetFuel = function(num)
        local num = c.check.Number(num, _min, _max)
        self.Fuel = num
    end
    --
    return self
end
