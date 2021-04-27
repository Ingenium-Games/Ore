-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[ 
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
-- ESX Team

Citizen.CreateThread(function()
	local IsDead = false
	while true do
		Citizen.Wait(0)
		local player = PlayerId()
		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()
			if IsPedFatallyInjured(playerPed) and not IsDead then
				IsDead = true
				local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
				local killerServerId = NetworkGetPlayerIndexFromPed(killer)
				if killer ~= playerPed and killerServerId ~= nil and NetworkIsPlayerActive(killerServerId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
				else
					PlayerKilled()
				end
			elseif not IsPedFatallyInjured(playerPed) then
				IsDead = false
			end
		end
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance     = GetDistanceBetweenCoords(victimCoords, killerCoords, true)
	local data = {
		VictimCoords = vector3(c.math.Decimals(victimCoords.x, 2), c.math.Decimals(victimCoords.y, 2), c.math.Decimals(victimCoords.z, 2)),
		KillerCoords = vector3(c.math.Decimals(killerCoords.x, 2), c.math.Decimals(killerCoords.y, 2), c.math.Decimals(killerCoords.z, 2)),
		--
		PlayerKill	= true,
		Cause		= killerWeapon,
		Distance    = c.math.Decimals(distance, 2),
		--
		KillerServerID = killerServerId,
		KillerClientID = killerClientId
	}
	TriggerEvent('Client:Character:Death', data)
	TriggerServerEvent('Server:Character:Death', data)
end

function PlayerKilled()
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(PlayerPedId())
	local data = {
		VictimCoords = vector3(c.math.Decimals(victimCoords.x, 2), c.math.Decimals(victimCoords.y, 2), c.math.Decimals(victimCoords.z, 2)),
		--
		PlayerKill = false,
		Cause     = GetPedCauseOfDeath(playerPed)
	}
	TriggerEvent('Client:Character:Death', data)
	TriggerServerEvent('Server:Character:Death', data)
end