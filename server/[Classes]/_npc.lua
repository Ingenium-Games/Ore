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

function c.class.NpcClass(entity)
    local self = {}
    --
    self.First_Name = c.rng.chars(10)
    self.Last_Name = c.rng.chars(10)
    self.Full_Name = self.First_Name .. " " .. self.Last_Name
    self.Age = math.random(17, 92)
    self.History = c.rng.chars(255)
    --
    return self
end
