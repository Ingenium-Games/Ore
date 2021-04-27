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
RegisterNetEvent("Client:Character:Death")
AddEventHandler("Client:Character:Death", function(data)
    if (data.PlayerKill == true) then

    else

    end
end)

RegisterNetEvent('Client:Time:Receive')
AddEventHandler('Client:Time:Receive', function(clock)
	assert(type(clock) == 'table', 'Invalid Lua type at argument #1, expected string, got '..type(clock))
    assert(clock.h <= 23, 'Invalid time hour passed to client, must be below 23, got '..clock.h)
    --
    NetworkOverrideClockMillisecondsPerGameMinute(60000)
    NetworkOverrideClockTime(clock.h, clock.m)
end)

-- Event to receive the data of the chosen character for the client.
RegisterNetEvent('Client:Character:Loaded')
AddEventHandler('Client:Character:Loaded', function(data)
    c.data.SetPlayer(data)
    c.data.SetLoadedStatus(true)
    c.data.SetLocale()
    Wait(100)
    c.data.ClientSync()
    TriggerEvent('Client:Character:Ready')
end)

-- Event to trigger other resources once the client has received the chosen characters data from the server.
RegisterNetEvent('Client:Character:Ready')
AddEventHandler('Client:Character:Ready', function()
    DisplayRadar(true)
    NetworkSetFriendlyFireOption(true)
    RemoveMultiplayerHudCash()
    SetPlayerHealthRechargeLimit(PlayerId(), 0)
    SetPedMinGroundTimeForStungun(PlayerPedId(), 12500)
    SetCanAttackFriendly(PlayerPedId(), true, false)
    SetPedSuffersCriticalHits(PlayerPedId(), true)
end)

