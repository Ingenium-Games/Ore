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
	assert(type(clock) == 'table', 'Invalid Lua type at argument #1, expected string, got '..type(clock))
    assert(clock.h <= 23, 'Invalid time hour passed to client, must be below 23, got '..clock.h)
    --
    NetworkOverrideClockMillisecondsPerGameMinute(60000)
    NetworkOverrideClockTime(clock.h, clock.m)
end)