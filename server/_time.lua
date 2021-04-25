--====================================================================================--
--  MIT License 2020 : Twiitchter
--====================================================================================--
c.time = {} -- functions
c.times = {
    h = 0,
    m = 0
}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.seed)
--====================================================================================--

RegisterNetEvent('Server:Request:Time')
AddEventHandler('Server:Request:Time', function(num)
	local src = source or tonumber(num)
	TriggerClientEvent('Client:Time:Recieve', src, c.times)
end)

function c.time.Update()
	local t = os.date('*t')
	c.times = {h = t.hour, m = t.min}
	SetConvarServerInfo('Time', string.format('%02d:%02d', c.times.h, c.times.m))
end

function c.time.ServerSync()
    local function sync()
        c.time.Update()
        SetTimeout(c.min, sync)
    end
    SetTimeout(c.min, sync)
end