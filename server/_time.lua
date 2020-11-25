--====================================================================================--
--  MIT License 2020 : Twiitchter
--====================================================================================--
_c.time = {
    h = 0,
    m = 0
}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
--====================================================================================--

RegisterNetEvent('Server:Request:Time')
AddEventHandler('Server:Request:Time', function(pass)
	local src = tonumber(pass)
	TriggerClientEvent('Client:Time.Recieve', src, _c.time)
end)

Citizen.CreateThread(function()
	while true do
        UpdateTime()
        Wait(conf.min)
	end
end)

function UpdateTime()
	local t = os.date('*t')
	_c.time = {h = t.hour, m = t.min}
	SetConvarServerInfo('Time', string.format('%02d:%02d', _c.time.h, _c.time.m))
end
