-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
_c.commands = {}
--[[
NOTES.
    - To enforce the requirement to hold the key down, add the + to the commands not commented out.
    - Example
    RegisterCommand('+cross', function() TriggerEvent("Client:Animation.CrossedArms", true, GetPlayerPed(-1)) end, false)
    RegisterCommand('-cross', function() TriggerEvent("Client:Animation.CrossedArms", false, GetPlayerPed(-1)) end, false)
    RegisterKeyMapping('+cross', 'Cross arms', 'keyboard', 'z')
]]--
math.randomseed(_c.seed)
-- ====================================================================================--

RegisterCommand('cross', function()
    TriggerEvent("Client:Animation.CrossedArms", true, GetPlayerPed(-1))
end, false)
RegisterKeyMapping('cross', 'Cross arms', 'keyboard', '1')

-- ====================================================================================--

RegisterCommand('hands', function()
    TriggerEvent("Client:Animation.HandsUp", true, GetPlayerPed(-1))
end, false)
RegisterKeyMapping('hands', 'Hands Up', 'keyboard', '2')

-- ====================================================================================--

RegisterCommand('armhold', function()
    TriggerEvent("Client:Animation.ArmHold", true, GetPlayerPed(-1))
end, false)
RegisterKeyMapping('armhold', 'Arm Hold', 'keyboard', '3')

-- ====================================================================================--

RegisterCommand('screenshot', function()
    TriggerEvent("Client:Screengrab")
end, false)
RegisterKeyMapping('screenshot', 'Grab a screenshot of your screen', 'keyboard', 'f11')

RegisterNetEvent("Client:Screengrab")
AddEventHandler("Client:Screengrab", function()
    exports['screenshot-basic']:requestScreenshotUpload(conf.imagehost, 'file', {
        encoding = 'jpg',
        quality = 0.82
    }, function(ret)
        local t = json.decode(ret)
        
        -- This is just an example to show you how to call and return the image if you use a image host like 'imgpush'
        TriggerEvent('chat:addMessage', {
            template = '<img src="{0}" style="width: 500px; height: 450px;" />',
            args = {conf.imagehost..''..t.filename}
        })
        TriggerEvent('chat:addMessage', {
            template = '<p> {0} </p>',
            args = {t.filename}
        })

    end)
end)
---
