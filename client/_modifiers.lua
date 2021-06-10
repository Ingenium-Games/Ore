-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.modifier = {} -- function level
c.modifiers = {    -- taken from server too.
    ["Hunger"] = 1,
    ["Thirst"] = 1,
    ["Stress"] = 1, 
}
--[[
NOTES.
    - Here will be the modifiers to the _status.lua, please note that hunger/thirst/stress
    - are the only ones currently supported. Please utilize the formentioned and expand upon it.
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

local _min = 1
local _max = 10
local _boost = 1

-- ====================================================================================--

--- Return the table of active modifiers. Table
function c.modifier.GetModifiers()
    return c.modifier
end

--- Sets the table of active modifiers.
---@param t table "Typically passed from the server as an internal table."
function c.modifier.SetModifiers(t)
    if t.Modifiers then
        c.modifier = t.Modifiers
    end
end

-- ====================================================================================--

--- Returns the Hunger modifier. Number
function c.modifier.GetHungerModifier()
    return c.modifier.Hunger
end

--- Sets the Hunger modifier between (1,10).
---@param v number "Can only be a number."
function c.modifier.SetHungerModifier(v)
    local val = c.check.Number(v, _min, _max)
    c.modifier.Hunger = val
end

-- ====================================================================================--

--- returns the Thirst modifier. Number
function c.modifier.GetThirstModifier()
    return c.modifier.Thirst
end

--- Sets the Thirst modifier between (1,10)
---@param v number "Can only be a number." 
function c.modifier.SetThirstModifier(v)
    local val = c.check.Number(v, _min, _max)
    c.modifier.Thirst = val
end

-- ====================================================================================--

--- Returns the Stress modifier. Number
function c.modifier.GetStressModifier()
    return c.modifier.Stress
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function c.modifier.SetStressModifier(v)
    local val = c.check.Number(v, _min, _max)
    c.modifier.Thirst = val
end

-- ====================================================================================--

--- Returns the current degrade booster value. Number
function c.modifier.GetDegradeBoost()
    return _boost
end

--- Sets a degrade booster to help reduce the modifiers. Like a Debuff.
---@param v number "Can only be a number."
function c.modifier.SetDegradeBoost(v)
    local val = c.check.Number(v, _min, _max)
    _boost = val
end

--- Loop over the modifers and decrease them.
function c.modifier.DegradeModifiers()
    for k,v in pairs(c.modifier) do    
        if v < _min then v = 1 end
        if v > _max then v = 10 end
        if v <= 10 and v > 1 then
            v = math.min(v - (1 * c.modifier.GetDegradeBoost()), 1)
        end
    end
end

-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(c.min * 10)
        c.modifier.DegradeModifiers()
    end
end)
