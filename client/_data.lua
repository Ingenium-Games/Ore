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

--- Upon joining, these are core functions to run internally prior to sending the join request to the server
---@param cb function "Callback function to run if any provided."
function c.data.Initilize(cb)
    -- Get time and update every minute.
    c.time.UpdateTime()
    --

    --
    if cb then
        cb()
    end
end

--- Returns the local from the local variable. String
function c.data.GetLocale()
    return c.locale
end

--- Takes local information from the `user` SQL table and sets it for the client.
function c.data.SetLocale()
    local xPlayer = c.data.GetPlayer()
    c.data.locale = xPlayer.GetLocale()
end

--- Sets the client as receieved the character data. Boolean
---@param bool boolean "Set loaded status to true or false."
function c.data.SetLoadedStatus(bool)
    if type(bool) == 'boolean' then
        c.CharacterLoaded = bool
    end
end

--- Returns if the client has finished loading. Boolean
function c.data.GetLoadedStatus()
    return c.CharacterLoaded
end

--- Sets the data to the local table on the client side.
---@param t table "Contains the table of data provided by the server to clinet on character selection."
function c.data.SetPlayer(t)
    c.Character = t
end

--- Returns the xPlayer passed from the server. Table
function c.data.GetPlayer()
    return c.Character
end

--- Shows a Spinny in the bottom left while sending data to the server.
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

--- Sends the packet of data to the server to register and update xPlayer
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
