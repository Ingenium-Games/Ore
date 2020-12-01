-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES:
    -
    -
    -
]] --
math.randomseed(c.seed)
-- ====================================================================================--
Citizen.CreateThread(function()
    while true do
        Wait(0)
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

-- Not per Frame natives by still need to remove for the role play experience.
Citizen.CreateThread(function()
    while true do
        InvalidateIdleCam()
        N_0x9e4cfff989258472()
        Wait(5000)
    end
end)
