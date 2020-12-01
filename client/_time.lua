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
RegisterNetEvent('Client:Time:Receive')
AddEventHandler('Client:Time:Receive', function(clock)
    SetMillisecondsPerGameMinute(60000)
    NetworkOverrideClockTime(clock.h, clock.m)
end)