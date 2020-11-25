-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --
-- ====================================================================================--
RegisterNetEvent('Client:Time:Receive')
AddEventHandler('Client:Time:Receive', function(clock)
    NetworkOverrideClockTime(clock.h, clock.m)
    SetMillisecondsPerGameMinute(60000)
end)