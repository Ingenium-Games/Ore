-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.stats = {}
c.status = {}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

-- GET
function c.status.GetHealth()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)    
    return health
end

function c.status.GetArmour()
    local ped = PlayerPedId()
    local armour = GetPedArmour(ped)    
    return armour 
end

function c.status.GetHunger()
    return 
end

function c.status.GetThirst()
    return 
end

function c.status.GetStress()
    return 
end

-- SET
function c.status.SetHealth(health)
    local ped = PlayerPedId()
    SetEntityHealth(ped, health)
end

function c.status.SetArmour(armour)
    SetPedArmour(ped, armour)

    -- run routines 
end

function c.status.SetHunger()
    -- run routines 
end

function c.status.SetThirst()
    -- run routines 
end

function c.status.SetStress()
    -- run routines 
end



function c.status.AddArmour(armour)
    local ped = PlayerPedId()
    AddArmourToPed(ped, armour) 
end





function c.status.Initialize(data)
    local ped = PlayerPedId()
    local ply = PlayerId()
    --
    if GetEntityMaxHealth(ped) <= 200 or GetEntityMaxHealth(ped) >= 401 then
        SetEntityMaxHealth(ped, conf.defaulthealth)
    end
    if GetPlayerMaxArmour(ply) <= 100 or GetPlayerMaxArmour(ply) >= 351 then
        SetPlayerMaxArmour(ply, conf.defaultarmour)
    end
    SetPlayerHealthRechargeLimit(ply, 0)
    SetPlayerHealthRechargeMultiplier(ply, 0)
    SetPedSuffersCriticalHits(ped, true)
    --
    SetPlayerInvincible(ply, false)
    --

end

--[[
-- health
local retval = GetEntityHealth(entity)
local retval = GetEntityMaxHealth(entity)
SetEntityHealth(entity, health)
local retval = GetPlayerHealthRechargeLimit(player)

---injured
local retval = IsPedInjured(ped)

---fatallyinjured
local retval = IsPedFatallyInjured(ped)

-- armour
local retval = 

SetPlayerMaxArmour(player, value)
AddArmourToPed(ped, amount)

local retval = GetPedArmour(ped)


-- hunger

-- thirst

-- stress
]]--