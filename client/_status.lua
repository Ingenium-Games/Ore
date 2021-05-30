-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.stats = {
    _min = 0,
    _max = 100,
    _time = {_sync = 1000, _hunger = 60000, _thirst = 60000, _stress = 60000 * 10}, -- a minute each, except Stress, increases every 10 minutes 
    ["Hunger"] = 100, -- Min 0 Max 100
    ["Thirst"] = 100, -- Min 0 Max 100
    ["Stress"] = 0, -- Min 0 Max 100
    }
c.status = {}
--[[
NOTES.
    - As health and armour are natives for the game, we dont need to worry much about the
    - additions to them from items etc as we can set max values, and have a default min
    - of 0.
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

local function CheckV(v)
    local val = 0
    assert(type(v) == 'number', 'Invalid Lua type at argument #1, expected number, got ' .. type(v))
    if type(v) ~= 'number' then
        return val
    else
        if v >= c.stats._min and v <= c.stats._max then
            val = v
        else
            c.debug("Unable to add value lesser than 0, or greater than 100.")
        end
    end
    return val
end

---------- Health
function c.status.GetHealth(ped)
    return GetEntityHealth(ped)
end

function c.status.SetHealth(ped, health)
    SetEntityHealth(ped, health)
end

----------


---------- Armour
function c.status.GetArmour(ped)
    return GetPedArmour(ped)
end

function c.status.SetArmour(ped, armour)
    SetPedArmour(ped, armour)
end

function c.status.AddArmour(ped, armour)
    AddArmourToPed(ped, armour) 
end

----------


---------- Hunger
function c.status.GetHunger()
    return c.stats.Hunger
end

function c.status.SetHunger(v)
    c.stats.Hunger = v
end

function c.status.AddHunger(v)
    local val = CheckV(v)
    local calc = c.stats.Hunger + val
    if calc >= 100 then
        c.stats.Hunger = c.stats._max
    else 
        c.stats.Hunger = c.stats.Hunger + val
    end
end

function c.status.RemoveHunger(v)
    local val = CheckV(v) 
    local calc = c.stats.Hunger - val
    if calc <= 0 then
        c.stats.Hunger = c.stats._min
    else 
        c.stats.Hunger = c.stats.Hunger - val
    end
end

----------


---------- Thisrt
function c.status.GetThirst()
    return c.stats.Thirst
end

function c.status.SetThirst(v)
    c.stats.Thirst = v 
end

function c.status.AddThirst(v)
    local val = CheckV(v)
    local calc = c.stats.Thirst + val
    if calc >= 100 then
        c.stats.Thirst = c.stats._max
    else 
        c.stats.Thirst = c.stats.Thirst + val
    end
end

function c.status.RemoveThirst(v)
    local val = CheckV(v)
    local calc = c.stats.Thirst - val
    if calc <= 0 then
        c.stats.Thirst = c.stats._min
    else 
        c.stats.Thirst = c.stats.Thirst - val
    end
end

----------


---------- Stress
function c.status.GetStress()
    return c.stats.Stress
end

function c.status.SetStress(v)
     c.stats.Stress = v
end

function c.status.AddStress(v)
    local val = CheckV(v)
    local calc = c.stats.Stress + val
    if calc >= 100 then
        c.stats.Stress = c.stats._max
    else 
        c.stats.Stress = c.stats.Stress + val
    end
end

function c.status.RemoveStress(v)
    local val = CheckV(v)
    local calc = c.stats.Stress - val
    if calc <= 0 then
        c.stats.Stress = c.stats._min
    else 
        c.stats.Stress = c.stats.Stress - val
    end
end

----------

function c.status.NUISync()
    local function Do()
        -- SendNuiMessage()
        SetTimeout(c.stats._time._sync, Do)
    end
    SetTimeout(c.stats._time._sync, Do)
end


function c.status.StartHungerDecrease()
    local function Do()
        local default = 1 * c.modifiers.GetHungerModifier()
        c.status.RemoveHunger(default)
        SetTimeout(c.stats._time._hunger, Do)
    end
    SetTimeout(c.stats._time._hunger, Do)
end

function c.status.StartThirstDecrease()
    local function Do()
        local default = 1 * c.modifiers.GetThirstModifier()
        c.status.RemoveThirst(default)
        SetTimeout(c.stats._time._thirst, Do)
    end
    SetTimeout(c.stats._time._thirst, Do)
end

function c.status.StartStressIncrease()
    local function Do()
        local default = 1 * c.modifiers.GetStressModifier()
        c.status.AddStress(default)
        SetTimeout(c.stats._time._stress, Do)
    end
    SetTimeout(c.stats._time._stress, Do)
end

----------

function c.status.SetPlayer(data)
    local ped = PlayerPedId()
    local ply = PlayerId()
    --
    -- Set default hp to 400 on spawn
    SetPedMaxHealth(ped, conf.defaulthealth)
    c.status.SetHealth(ped, conf.defaulthealth)
    --
    -- Set default armour to 0 on spawn
    SetPlayerMaxArmour(ply, conf.defaultarmour)
    c.status.SetArmour(ped, 0)
    --
    -- These will be usesd in healing items.
    SetPlayerHealthRechargeLimit(ply, 0)
    SetPlayerHealthRechargeMultiplier(ply, 0)
    SetPedSuffersCriticalHits(ped, true) --  Headshot ratios boi.
    --
    -- This may be true if you take like 50kgs of cocaine.
    SetPlayerInvincible(ply, false)
    --
    -- time to gain our data from the server.
    if data then
        if data.Health then
            c.status.SetHealth(ped, data.Health)
        end
        if data.Armour then
            c.status.SetArmour(ped, data.Armour)
        end
        if data.Hunger then
            c.status.SetHunger(data.Hunger)
        end
        if data.Thirst then
            c.status.SetThirst(data.Thirst)
        end
        if data.Stress then
            c.status.SetStress(data.Stress)
        end
    end
    -- Begin the NUI Sync
    c.status.NUISync()
    -- Give it 30 seconds then begin the routines
    Wait(c.sec * 30)
    -- Begin Routines / Timeouts
    c.status.StartHungerDecrease()
    c.status.StartThirstDecrease()
    c.status.StartStressIncrease()
    --
end