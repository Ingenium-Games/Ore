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

--health
local retval = GetPedMaxHealth(ped)
local retval = GetEntityHealth(entity)
local retval = GetEntityMaxHealth(entity)

SetEntityHealth(entity , health)
SetEntityMaxHealth(entity , value)

local retval = GetPlayerHealthRechargeLimit(player)

SetPlayerHealthRechargeLimit(player, limit)
SetPlayerHealthRechargeMultiplier(player, regenRate)
SetPlayerInvincible(player, toggle)

---injured
local retval = IsPedInjured(ped)

---fatallyinjured
local retval = IsPedFatallyInjured(ped)

--armour
local retval = GetPlayerMaxArmour(player)

SetPlayerMaxArmour(player, value)
AddArmourToPed(ped , amount)

local retval = GetPedArmour(ped)

SetPedArmour(ped , amount)

--hunger

--thirst

--stress