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
    local self = {}
    -- enable table searching.
    self.__index = self
    -- disable altering the direct line of data, must use set and get.
    self.__metatable = self
    --
    self.Fuel = math.random(73,100)
    --
    self.GetFuel = function()
        return self.Fuel
    end
    --
    self.AddFuel = function(num)
        if type(num) == 'integer' then
            self.Fuel = (self.Fuel + num)
            if self.Fuel >= 100 then
                self.Fuel = 100
            end
        end
    end
    --
    self.RemoveFuel = function(num)
        if type(num) == 'integer' then
            self.Fuel = (self.Fuel - num)
            if self.Fuel <= 0 then
                self.Fuel = 0
            end
        end
    end
    --
    self.SetFuel = function(num)
        if num > 100 or num < 0 then
            c.debug("Unable to set vehicle fuel level above 100 or below 0.")
        else
            self.Fuel = num
        end
    end
end
