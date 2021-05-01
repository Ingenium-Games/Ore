-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - These are the events within the OneSync Server events found at :
    - https://docs.fivem.net/docs/scripting-reference/events/server-events/


GetEntityType( entity )
0 = no entity
1 = ped
2 = vehicle
3 = object

]] --
-- ====================================================================================--

AddEventHandler('weaponDamageEvent', function()

end)

AddEventHandler('vehicleComponentControlEvent', function()

end)

AddEventHandler('respawnPlayerPedEvent', function()

end)

AddEventHandler('explosionEvent', function()
    CancelEvent()
end)

AddEventHandler('entityCreated', function(ent)
    if DoesEntityExist(ent) then
        local model = GetEntityModel(ent)
        for _, v in pairs(conf.disable.vehicles) do
            local restrictedVehicleModel = conf.disable.vehicles[i]
            if (model == restrictedVehicleModel) then
                DeleteEntity(ent)
            end
        end
    end
    -- Testing setting all vehicles that are CARS - to have a fuel as a statebag with set, get add and remove fuel functions.
    if GetEntityType(ent) == 2 then
        Entity(ent).state = c.class.VehicleClass(ent)
    end
end)

AddEventHandler('entityCreating', function(ent)
    local model = GetEntityModel(ent)
    for _, v in pairs(conf.disable.vehicles) do
        local restrictedVehicleModel = conf.disable.vehicles[i]
        if (model == restrictedVehicleModel) then
            CancelEvent()
        end
    end
end)

AddEventHandler('entityRemoved', function()

end)

AddEventHandler('playerEnteredScope', function()

end)

AddEventHandler('playerLeftScope', function()

end)
