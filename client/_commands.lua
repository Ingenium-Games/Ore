-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.commands = {}
--[[
NOTES.
    - To enforce the requirement to hold the key down, add the + to the commands not commented out.
    - Example
    RegisterCommand('+cross', function() TriggerEvent("Client:Animation.CrossedArms", true, GetPlayerPed(-1)) end, false)
    RegisterCommand('-cross', function() TriggerEvent("Client:Animation.CrossedArms", false, GetPlayerPed(-1)) end, false)
    RegisterKeyMapping('+cross', 'Cross arms', 'keyboard', 'z')
]]--
math.randomseed(c.seed)
-- ====================================================================================--

RegisterCommand('cross', function()
    TriggerEvent("Client:Animation.CrossedArms", true, GetPlayerPed(-1))
end, false)
RegisterKeyMapping('cross', 'Cross arms', 'keyboard', 'NumPad1')

-- ====================================================================================--

RegisterCommand('hands', function()
    TriggerEvent("Client:Animation.HandsUp", true, GetPlayerPed(-1))
end, false)
RegisterKeyMapping('hands', 'Hands Up', 'keyboard', 'NumPad2')

-- ====================================================================================--

RegisterCommand('armhold', function()
    TriggerEvent("Client:Animation.ArmHold", true, GetPlayerPed(-1))
end, false)
RegisterKeyMapping('armhold', 'Arm Hold', 'keyboard', 'NumPad3')

-- ====================================================================================--
