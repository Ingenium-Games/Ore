-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
_c.data = {}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
-- ====================================================================================--
_c.data.obj = nil
_c.data.loaded = false
_c.data.locale = conf.locale

function _c.data.GetLocale()
    return _c.data.locale
end

function _c.data.SetLocale()
    local Player = _c.data.GetPlayer()
    _c.data.locale = Player.GetLocale()
end

function _c.data.SetLoadedStatus(bool)
    if type(bool) == 'boolean' then
        _c.data.loaded = bool
    end
end

function _c.data.GetLoadedStatus()
    return _c.data.loaded
end

function _c.data.SetPlayer(t)
    _c.data.obj = t
end

function _c.data.GetPlayer()
    return _c.data.obj
end

function _c.data.IsBusy()
    BeginTextCommandBusyspinnerOn('FM_COR_AUTOD')
    EndTextCommandBusyspinnerOn(5)
end

function _c.data.NotBusy()
    BusyspinnerOff()
    PreloadBusyspinner()
end

function _c.data.ClientSync()
    Citizen.CreateThread(function()
        while true do
            Wait(conf.clientsync)
            if _c.data.loaded then
                _c.data.IsBusy()
                _c.data.SendPacket()
                _c.data.NotBusy()
            end
        end
    end)
end

function _c.data.SendPacket()
    local data = {}
    -- Coords
        local loc = GetEntityCoords(PlayerPedId())
        local ords = {
            x = _c.math.decimals(loc.x, 2),
            y = _c.math.decimals(loc.y, 2),
            z = _c.math.decimals(loc.z, 2)
        }
        data.Coords = ords
    -- 

    -- 

    TriggerServerEvent('Server:Packet.Update', data)
end
------------------------------------------------------------------------------