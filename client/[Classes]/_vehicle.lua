
--- Internal [F] - Take the passed tables on the Entity State and place them on the vehicle.
---@param entity any "Entity ID"
---@param networkid any "Network ID"
function c.class.VehicleClass(entity, networkid)
    NetworkRequestControlOfNetworkId(networkid)
    local vehicle = c.GetEntity(entity)
    -- All the client needs to do is import the Mods and Condition from the state, and amend / update upon return to DB.
    c.SetVehicleModifications(entity, vehicle.Modifications)
    c.SetVehicleCondition(entity, vehicle.Condition)
end

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


