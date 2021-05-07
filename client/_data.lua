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
                c.data.SendPacket()
                c.NotBusy()
            end
        end
    end)
end

function c.data.SendPacket()
    local ped = PlayerPedId()
    local data = {}
    -- Stats / HP vs 
    data.Health = c.status.GetHealth()
    data.Armour = c.status.GetArmour()
    data.Hunger = c.status.GetHunger()
    data.Thirst = c.status.GetThirst()
    data.Stress = c.status.GetStress()
    -- Coords
    local loc = GetEntityCoords(ped)
    --
    data.Coords = {
        x = c.math.Decimals(loc.x, 2),
        y = c.math.Decimals(loc.y, 2),
        z = c.math.Decimals(loc.z, 2)
    }
    -- 

    TriggerServerEvent('Server:Packet:Update', data)
end
------------------------------------------------------------------------------
