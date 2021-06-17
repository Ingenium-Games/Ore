
function c.class.VehicleClass(entity, networkid)
    NetworkRequestControlOfNetworkId(networkid)
    local vehicle = c.GetEntity(entity)
    c.SetVehicleModifications(entity, vehicle.Modifications)
    c.SetVehicleCondition(entity, vehicle.Condition)



end




c.RegisterClientCallback('Request:Create:VehicleClass', function(table)
    local tab = c.check.Table(table)
    local entity, networkid, safespawn = c.CreateVehicle(tab.Model, tab.Coords.x, tab.Coords.y, tab.Coords.z, tab.Coords.h)    
    if IsVehicleOnAllWheels(entity) and safespawn then
        local result = c.TriggerServerCallback('Request:Create:VehicleClass', networkid, tab.Plate)
        if result then
            c.class.VehicleClass(entity, networkid)
        end
    else
    
    end
end)


