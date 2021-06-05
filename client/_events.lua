-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--
RegisterNetEvent("Client:Character:Death")
AddEventHandler("Client:Character:Death", function(data)
    if (data.PlayerKill == true) then
        
    else
        
    end
end)

-- Event to receive the data of the chosen character for the client.
RegisterNetEvent('Client:Character:Loaded')
AddEventHandler('Client:Character:Loaded', function(data)
    -- Add routines to do upon resicing the data from server.
    c.data.SetPlayer(data) -- Full table will be in here
    c.data.SetLoadedStatus(true)
    Wait(250) -- Give yourself a moment prior to marked as loaded.
    --
    c.status.SetPlayer(c.data.GetPlayer()) -- This will only use the Health, Armour, Hunger, Thirst and Stress as a sub table c.stats
    --
    Wait(250) -- Give yourself a moment prior to Syncing from loaded.
    --
    c.data.ClientSync()
    -- Trigger any events after the Ready State.
    TriggerEvent('Client:Character:Ready')
end)

-- Event to trigger other resources once the client has received the chosen characters data from the server.
RegisterNetEvent('Client:Character:Ready')
AddEventHandler('Client:Character:Ready', function()
    local ped = PlayerPedId()
    local ply = PlayerId()
    -- DisplayRadar(true)
    
    --
    SetPedMinGroundTimeForStungun(ped, 12500)
    --
    SetCanAttackFriendly(ped, true, false)
    NetworkSetFriendlyFireOption(true)
    --
    TriggerServerEvent("Server:Character:Ready")
end)