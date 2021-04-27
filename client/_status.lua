-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.status = {}
c.statuses = {}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

--health

local retval --[[ integer ]] =
	GetPedMaxHealth(
		ped --[[ Ped ]]
	)
local retval --[[ integer ]] =
	GetEntityHealth(
		entity --[[ Entity ]]
	)

local retval --[[ integer ]] =
	GetEntityMaxHealth(
		entity --[[ Entity ]]
	)
SetEntityHealth(
	entity --[[ Entity ]], 
	health --[[ integer ]]
)

SetEntityMaxHealth(
	entity --[[ Entity ]], 
	value --[[ integer ]]
)
local retval --[[ number ]] =
	GetPlayerHealthRechargeLimit(
		player --[[ Player ]]
	)
SetPlayerHealthRechargeLimit(
	player --[[ Player ]], 
	limit --[[ number ]]
)
SetPlayerHealthRechargeMultiplier(
	player --[[ Player ]], 
	regenRate --[[ number ]]
)
SetPlayerInvincible(
	player --[[ Player ]], 
	toggle --[[ boolean ]]
)

---injured
local retval --[[ boolean ]] =
	IsPedInjured(
		ped --[[ Ped ]]
	)

---fatallyinjured
local retval --[[ boolean ]] =
	IsPedFatallyInjured(
		ped --[[ Ped ]]
	)

--armour
local retval --[[ integer ]] =
	GetPlayerMaxArmour(
		player --[[ Player ]]
	)
	SetPlayerMaxArmour(
	player --[[ Player ]], 
	value --[[ integer ]]
)AddArmourToPed(
	ped --[[ Ped ]], 
	amount --[[ integer ]]
)
local retval --[[ integer ]] =
	GetPedArmour(
		ped --[[ Ped ]]
	)
	SetPedArmour(
	ped --[[ Ped ]], 
	amount --[[ integer ]]
)

--hunger

--thirst

--stress