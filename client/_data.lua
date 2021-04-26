-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.data = {}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.seed)
-- ====================================================================================--
c.data.obj = nil
c.data.loaded = false
c.data.locale = conf.locale

function c.data.GetLocale()
    return c.data.locale
end

function c.data.SetLocale()
    local Player = c.data.GetPlayer()
    c.data.locale = Player.GetLocale()
end

function c.data.SetLoadedStatus(bool)
    if type(bool) == 'boolean' then
        c.data.loaded = bool
    end
end

function c.data.GetLoadedStatus()
    return c.data.loaded
end

function c.data.SetPlayer(t)
    c.data.obj = t
end

function c.data.GetPlayer()
    return c.data.obj
end

function c.data.ClientSync()
    Citizen.CreateThread(function()
        while true do
            Wait(conf.clientsync)
            if c.data.loaded then
                c.IsBusy()
                c.data.SendPacket()
                c.NotBusy()
            end
        end
    end)
end

function c.data.SendPacket()
    local data = {}
    -- Coords
        local loc = GetEntityCoords(PlayerPedId())
        local ords = {
            x = c.math.decimals(loc.x, 2),
            y = c.math.decimals(loc.y, 2),
            z = c.math.decimals(loc.z, 2)
        }
        data.Coords = ords
    -- 
        data.src = GetPlayerServerId(PlayerID())
    -- 

    TriggerServerEvent('Server:Packet:Update', data)
end
------------------------------------------------------------------------------