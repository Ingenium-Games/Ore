-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES:
    -
    -
    -
]] --
-- ====================================================================================--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            DisplayRadar(false)
            TriggerServerEvent('PlayerConnecting:Server:Connecting')
            return
        end
    end
end)

-- Event to receive the data of the chosen character for the client.
RegisterNetEvent('Client:Character:Loaded')
AddEventHandler('Client:Character:Loaded', function(data)
    _c.data.SetPlayer(data)
    _c.data.SetLoadedStatus(true)
    Wait(100)
    _c.data.ClientSync()
    TriggerEvent('Client:Character:Ready')
end)

-- Event to trigger other resources once the client has received the chosen characters data from the server.
RegisterNetEvent('Client:Character:Ready')
AddEventHandler('Client:Character:Ready', function()
    NetworkSetFriendlyFireOption(true)
    RemoveMultiplayerHudCash()
    SetPlayerHealthRechargeLimit(PlayerId(), 0)
    SetPedMinGroundTimeForStungun(PlayerPedId(), 8500)
    SetCanAttackFriendly(PlayerPedId(), true, false)
    SetPedSuffersCriticalHits(PlayerPedId(), false)
end)

-- Per Frame natives to enhance the role play experience.
Citizen.CreateThread(function()
    while true do
        Wait(0)
        HideAreaAndVehicleNameThisFrame()
        HideHudComponentThisFrame(19)
        HudWeaponWheelIgnoreSelection()
        ThefeedHideThisFrame()
    end
end)
