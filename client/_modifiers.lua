-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.modifier = {
    ["Hunger"] = 1,
    ["Thirst"] = 1,
    ["Stress"] = 1, 
}
c.modifiers = {}
--[[
NOTES.
    - Here will be the modifiers to the _status.lua, please note that hunger/thirst/stress
    - are the only ones currently supported. Please utilize the formentioned and expand upon it.
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
local _min, _max, _boost = 1, 10, 1

local function CheckV(v)
    local val = 1
    assert(type(v) == 'number', 'Invalid Lua type at argument #1, expected number, got ' .. type(v))
    if type(v) ~= 'number' then
        return val
    else
        if v >= _min and v <= _max then
            val = v
        else
            c.debug("Unable to add value lesser than 0, or greater than 100.")
        end
    end
    return val
end

function c.modifiers.GetModifiers()
    return c.modifier
end

function c.modifiers.SetModifiers(t)
    c.modifier = t
end

function c.modifiers.GetHungerModifier()
    return c.modifier.Hunger
end

function c.modifiers.SetHungerModifier(v)
    local val = CheckV(v)
    c.modifier.Hunger = val
end

function c.modifiers.GetThirstModifier()
    return c.modifier.Thirst
end

function c.modifiers.SetThirstModifier(v)
    local val = CheckV(v)
    c.modifier.Thirst = val
end


function c.modifiers.GetStressModifier()
    return c.modifier.Stress
end

function c.modifiers.SetStressModifier(v)
    local val = CheckV(v)
    c.modifier.Thirst = val
end

function c.modifiers.GetDegradeBoost()
    return _boost
end

function c.modifiers.SetDegradeBoost(v)
    local val = CheckV(v)
    _boost = val
end

function c.modifiers.DegradeModifiers()
    for k,v in pairs(c.modifier) do    
        if v < _min then v = 1 end
        if v > _max then v = 10 end
        if v <= 10 and v >= 1 then
            v = v - (1 * c.modifiers.GetDegradeBoost())
        end
    end
    --
    c.modifiers.SetHungerModifier(c.modifier.Hunger)
    c.modifiers.SetThirstModifier(c.modifier.Thirst)
    c.modifiers.SetStressModifier(c.modifier.Stress)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(c.min * 10)
        c.modifiers.DegradeModifiers()
    end
end)
