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

local _min = 1
local _max = 10
local _boost = 1

-- ====================================================================================--

function c.modifiers.GetModifiers()
    return c.modifier
end

function c.modifiers.SetModifiers(t)
    c.modifier = t
end

-- ====================================================================================--

function c.modifiers.GetHungerModifier()
    return c.modifier.Hunger
end

function c.modifiers.SetHungerModifier(v)
    local val = c.check.Number(v, _min, _max)
    c.modifier.Hunger = val
end

-- ====================================================================================--

function c.modifiers.GetThirstModifier()
    return c.modifier.Thirst
end

function c.modifiers.SetThirstModifier(v)
    local val = c.check.Number(v, _min, _max)
    c.modifier.Thirst = val
end

-- ====================================================================================--

function c.modifiers.GetStressModifier()
    return c.modifier.Stress
end

function c.modifiers.SetStressModifier(v)
    local val = c.check.Number(v, _min, _max)
    c.modifier.Thirst = val
end

-- ====================================================================================--

function c.modifiers.GetDegradeBoost()
    return _boost
end

function c.modifiers.SetDegradeBoost(v)
    local val = c.check.Number(v, _min, _max)
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

-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(c.min * 10)
        c.modifiers.DegradeModifiers()
    end
end)
