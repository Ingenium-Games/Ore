-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.seed)
-- ====================================================================================--
RegisterNetEvent("Server:Character:Death")
AddEventHandler("Server:Character:Death", function(data)
    local src = data.src or source
    if (data.PlayerKill == true) then
        
    else
        
    end
end)

RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function(data)
    local src = data.src or source
    c.inst.SetPlayerDefault(src)
end)

RegisterNetEvent("Server:Character:Loaded")
AddEventHandler("Server:Character:Loaded", function(data)
    local src = data.src or source
    c.inst.SetPlayerDefault(src)
end)

RegisterNetEvent('Server:Instance:Player:Default')
AddEventHandler('Server:Instance:Player:Default', function(data)
    local src = data.src or source
    c.inst.SetPlayerDefault(src)
end)

RegisterNetEvent('Server:Request:Time')
AddEventHandler('Server:Request:Time', function(data)
	local src = data.src or source
	TriggerClientEvent('Client:Time:Recieve', src, c.times)
end)

-- ====================================================================================--

RegisterNetEvent('Server:Packet:Update')
AddEventHandler('Server:Packet:Update', function(data)
	local src = data.src or source
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.SetCoords(data.Coords)
end)

