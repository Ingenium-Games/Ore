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
math.randomseed(c.Seed)
-- ====================================================================================--

-- functions to run prior to the player connecting server sequence.
function c.data.Initilize(cb)
    -- Get time and update every minute.
    c.time.UpdateTime()
    --

    --
    if cb then
        cb()
    end
end

function c.data.GetLocale()
    return c.locale
end

function c.data.SetLocale()
    local xPlayer = c.data.GetPlayer()
    c.data.locale = xPlayer.GetLocale()
end

function c.data.SetLoadedStatus(bool)
    if type(bool) == 'boolean' then
        c.CharacterLoaded = bool
    end
end

function c.data.GetLoadedStatus()
    return c.CharacterLoaded
end

function c.data.SetPlayer(t)
    c.Character = t
end

function c.data.GetPlayer()
    return c.Character
end

function c.data.ClientSync()
    Citizen.CreateThread(function()
        while true do
            Wait(conf.clientsync)
            if c.data.GetLoadedStatus() then
                c.IsBusy()
                Citizen.Wait(500)
                c.data.SendPacket()
                Citizen.Wait(500)
                c.NotBusy()
            end
        end
    end)
end

function c.data.SendPacket()
    local ped = PlayerPedId()
    local data = {}
    -- Stats / HP vs 
    data.Health = c.math.Decimals(c.status.GetHealth(ped), 0)
    data.Armour = c.math.Decimals(c.status.GetArmour(ped), 0)
    data.Hunger = c.math.Decimals(c.status.GetHunger(), 0)
    data.Thirst = c.math.Decimals(c.status.GetThirst(), 0)
    data.Stress = c.math.Decimals(c.status.GetStress(), 0)
    -- Modifiers
    data.Modifiers = c.modifiers.GetModifiers()
    -- Coords
    local loc = GetEntityCoords(ped)
    data.Coords = {
        x = c.math.Decimals(loc.x, 2),
        y = c.math.Decimals(loc.y, 2),
        z = c.math.Decimals(loc.z, 2)
    }
    TriggerServerEvent('Server:Packet:Update', data)
end
------------------------------------------------------------------------------
