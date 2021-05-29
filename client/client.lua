-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES:
    -
    -
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            --    
            c.data.Initilize(function()
                DisplayRadar(false)
                RemoveMultiplayerHudCash()
                TriggerServerEvent('Server:PlayerConnecting')
                --
                c.time.UpdateTime()

            end)
            --
            return
        end
    end
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
