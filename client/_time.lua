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
    NetworkOverrideClockMillisecondsPerGameMinute(60000)
    NetworkOverrideClockTime(clock.h, clock.m)
end)