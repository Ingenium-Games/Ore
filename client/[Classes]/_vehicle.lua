
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

