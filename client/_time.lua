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
RegisterNetEvent('Client:Time:Receive')
AddEventHandler('Client:Time:Receive', function(clock)
    SetMillisecondsPerGameMinute(60000)
    NetworkOverrideClockTime(clock.h, clock.m)
end)