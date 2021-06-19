-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
-- https://github.com/pitermcflebor/pmc-callbacks (MIT LICENSE)

RegisterNetEvent('Callback:Client')
AddEventHandler('Callback:Client', function(eventName, ...)
    local p = promise.new()

    TriggerEvent(('__CB:Client:%s'):format(eventName), function(...)
        p:resolve({...})
    end, ...)

    local result = Citizen.Await(p)
    TriggerServerEvent(('Callback:Server:%s'):format(eventName), table.unpack(result))
end)

function c.TriggerServerCallback(eventName, ...)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))

    local p = promise.new()
    local ticket = GetGameTimer()

    RegisterNetEvent(('Callback:Client:%s:%s'):format(eventName, ticket))
    local e = AddEventHandler(('Callback:Client:%s:%s'):format(eventName, ticket), function(...)
        p:resolve({...})
    end)

    TriggerServerEvent('Callback:Server', eventName, ticket, ...)

    local result = Citizen.Await(p)
    RemoveEventHandler(e)
    return table.unpack(result)
end

function c.RegisterClientCallback(eventName, fn)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))
    assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got ' .. type(fn))

    AddEventHandler(('__CB:Client:%s'):format(eventName), function(cb, ...)
        cb(fn(...))
    end)
end

-- ====================================================================================--

--- [E] - Passed Table of data results in creation of vehicle client side, to pass result to server, to generate and pull info from the server, to then return to the client to finalise and validate all changes to append to the vehicle.
---@param table table "{Model = hash, Coords = {c,y,z,h}, Owned = bool, Plate = string}"
c.RegisterClientCallback('Request:Create:VehicleClass', function(table)
    local tab = c.check.Table(table)
    local entity, networkid, safespawn = c.CreateVehicle(tab.Model, tab.Coords.x, tab.Coords.y, tab.Coords.z, tab.Coords.h)    
    if IsVehicleOnAllWheels(entity) and safespawn then
        -- Once the Vehicle is created, It sends a positive return to server, to query the network id,
        -- and Generate a class server side, AND if the car is player OWNED, it will pull DB info for it
        -- And append it to the entity AND contain a server sided table block to import from.
        local result = c.TriggerServerCallback('Request:Create:VehicleClass', networkid, tab.Owned, tab.Plate)
        if result then
            c.class.VehicleClass(entity, networkid)
            return true
        end
    else
        c.debug("Vehicle not spawned on all 4 wheels safely.")
        return false
    end
    return false
end)


