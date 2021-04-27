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
RegisterNetEvent('Client:Character:Open')
AddEventHandler('Client:Character:Open', function(Command, Data)
    SetNuiFocus(false, false)
    SetNuiFocus(true, true)
    SendNUIMessage({
        message = Command,
        packet = Data
    })
end)

RegisterNUICallback('Client:Character:Join', function(Data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('Server:Character:Request:Join', Data.ID)
    cb("ok")
end)

-- Not currently in use...
RegisterNUICallback('Client:Character:Delete', function(Data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('Server:Character:Request:Delete', Data.ID)
    cb("ok")
end)

RegisterNUICallback('Client:Character:Create', function(Data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('Server:Character:Request:Create', Data.First_Name, Data.Last_Name, Data.Height, Data.Birth_Date)
    cb("ok")
end)

------------------------------------------------------------------------------
--  While in join menu, Events and Triggers
--  Inspired by Kashacters. Still to rebuild once the cameras.lua is built.

local cam = nil
local cam2 = nil
local intro = nil

--
RegisterNetEvent('Client:Character:OpeningMenu')
AddEventHandler('Client:Character:OpeningMenu', function()
    -- Set false for switch command.
    c.data.SetLoadedStatus(false)
    --
    SetTimecycleModifier('default')
    SetEntityCoords(GetPlayerPed(-1), 0, 0, 0)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    intro = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 313.78, -1403.07, 189.53, 0.00, 0.00, 45.00, 100.00,
        false, 0)
    SetCamActive(intro, true)
    RenderScriptCams(true, false, 1, true, true)
end)

-- Taken over by the creator resource for initial creation...
RegisterNetEvent('Client:Character:FirstSpawn')
AddEventHandler('Client:Character:FirstSpawn', function(Character_ID)
    SetTimecycleModifier('default')
    SetCamActive(cam, false)
    SetCamActive(cam2, false)
    SetCamActive(intro, false)
    DestroyCam(cam, true)
    DestroyCam(cam2, true)
    DestroyCam(intro, true)
end)

-- Respawn in on last saved coords.
RegisterNetEvent('Client:Character:ReSpawn')
AddEventHandler('Client:Character:ReSpawn', function(Character_ID, Coords)
    SetTimecycleModifier('default')
    SetEntityCoords(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 313.78, -1403.07, 189.53, 0.00, 0.00, 45.00, 100.00,
               false, 0)
    PointCamAtCoord(cam2, Coords.x, Coords.y, Coords.z + 200)
    SetCamActiveWithInterp(cam2, intro, 900, 1, 1)
    Citizen.Wait(900)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Coords.x, Coords.y, Coords.z + 200, 300.00, 0.00, 0.00, 100.00,
              false, 0)
    PointCamAtCoord(cam, Coords.x, Coords.y, Coords.z + 2)
    SetCamActiveWithInterp(cam, cam2, 3700, 1, 1)
    Citizen.Wait(3700)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, 1, 1)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    Citizen.Wait(500)
    SetCamActive(cam, false)
    SetCamActive(cam2, false)
    SetCamActive(intro, false)
    DestroyCam(cam, true)
    DestroyCam(cam2, true)
    DestroyCam(intro, true)
    --
    TriggerServerEvent('skin:LoadSkin')
end)
