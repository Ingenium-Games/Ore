-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
_c.animations = {}
--[[
NOTES.
    -
    -
    -
]] --
-- ====================================================================================--
local function GetPed(Ped)
    if Ped == nil then
        Ped = GetPlayerPed(-1)
    else
        return Ped
    end
    return Ped
end
-- ====================================================================================--
RegisterNetEvent("Client:Animation.CrossedArms")
AddEventHandler("Client:Animation.CrossedArms", function(Bool, Ped)
    local ped = GetPed(Ped)
    local dict = "amb@world_human_hang_out_street@female_arms_crossed@base" 
    local anim = "base" 
    --
    RequestAnimDict(dict)
    Wait(100)
    --
    if Bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation.HandsUp")
AddEventHandler("Client:Animation.HandsUp", function(Bool, Ped)
    local ped = GetPed(Ped)
    local dict = "missminuteman_1ig_2"
    local anim = "handsup_enter"
    --
    RequestAnimDict(dict)
    Wait(100)
    --
    if Bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--
RegisterNetEvent("Client:Animation.ArmHold")
AddEventHandler("Client:Animation.ArmHold", function(Bool, Ped)
    local ped = GetPed(Ped)
    local dict = "anim@amb@nightclub@peds@"
    local anim = "amb_world_human_hang_out_street_female_hold_arm_idle_b"
    --
    RequestAnimDict(dict)
    Wait(100)
    --
    if Bool and not IsEntityPlayingAnim(ped, dict, anim, 3) then
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        RemoveAnimDict(dict)
    else
        ClearPedTasks(ped)
        RemoveAnimDict(dict)
    end
end)
-- ====================================================================================--