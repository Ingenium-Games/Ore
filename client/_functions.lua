-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

function c.func(...)
    local arg = {...}
    local status, val = c.err(unpack(arg))
    return val
end

function c.err(func, ...)
    local arg = {...}
    return xpcall(function()
        return c.func(unpack(arg))
    end, function(err)
        return c.error(err)
    end)
end

function c.error(err)
    if conf.error then
        if type(err) == 'string' then
            print("   ^7[^3Error^7]:  " .. "==    ", err)
            print(debug.traceback(_, 2))
        else
            print("   ^7[^3Error^7]:  " .. "==    ", 'Unable to type(err) == string. [err] = ', err)
            print(debug.traceback(_, 2))
        end
    end
end

function c.debug(str)
    if conf.debug then
        print("   ^7[^6Debug^7]:  " .. "==    ", str)
    end
end

-- ====================================================================================--
-- https://forum.cfx.re/t/tutorial-cancellable-function-usage/137558

CancellationToken = {}
CancellationToken.__index = CancellationToken

function CancellationToken.MakeToken(cancellationHandler)
    local self = {}

    setmetatable(self, CancellationToken)

    self._cancelled = false

    if cancellationHandler then
        self._cancellationHandler = cancellationHandler
    end
end

function CancellationToken:Cancel()
    if self._cancelled then
        return
    end

    self._cancelled = true

    if self._cancellationHandler then
        self._cancellationHandler()
    end
end

function CancellationToken:WasCancelled()
    return self._cancelled
end

function c.CancellableToken(cb)
    return CancellationToken.MakeToken(cb)
end

function c.CancellableWait(ms, token)
    Citizen.Wait(ms)
    if token:WasCancelled() then
        CancelEvent()
    end
end

-- ====================================================================================--
-- https://github.com/pitermcflebor/pmc-callbacks (MIT LICENSE)

RegisterNetEvent('__pmc_callback:client')
AddEventHandler('__pmc_callback:client', function(eventName, ...)
    local p = promise.new()

    TriggerEvent(('c__pmc_callback:%s'):format(eventName), function(...)
        p:resolve({...})
    end, ...)

    local result = Citizen.Await(p)
    TriggerServerEvent(('__pmc_callback:server:%s'):format(eventName), table.unpack(result))
end)

TriggerServerCallback = function(eventName, ...)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))

    local p = promise.new()
    local ticket = GetGameTimer()

    RegisterNetEvent(('__pmc_callback:client:%s:%s'):format(eventName, ticket))
    local e = AddEventHandler(('__pmc_callback:client:%s:%s'):format(eventName, ticket), function(...)
        p:resolve({...})
    end)

    TriggerServerEvent('__pmc_callback:server', eventName, ticket, ...)

    local result = Citizen.Await(p)
    RemoveEventHandler(e)
    return table.unpack(result)
end

RegisterClientCallback = function(eventName, fn)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))
    assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got ' .. type(fn))

    AddEventHandler(('c__pmc_callback:%s'):format(eventName), function(cb, ...)
        cb(fn(...))
    end)
end

-- wrappers for the pmc callbacks
function c.TriggerServerCallback(eventName, ...)
    TriggerServerCallback(eventName, ...)
end

function c.RegisterClientCallback(eventName, fn)
    RegisterClientCallback(eventName, fn)
end

-- ====================================================================================--

function c.IsBusy()
    BeginTextCommandBusyspinnerOn('FM_COR_AUTOD')
    EndTextCommandBusyspinnerOn(5)
end

function c.NotBusy()
    BusyspinnerOff()
    PreloadBusyspinner()
end

function c.PleaseWait()
    BeginTextCommandBusyspinnerOn('PM_WAIT')
    EndTextCommandBusyspinnerOn(5)
end

function c.IsBusyPleaseWait(ms, cb)
    c.PleaseWait()
    --
    Citizen.Wait(ms / 2)
    if cb then
        cb()
    end
    Citizen.Wait(ms / 2)
    --
    c.NotBusy()
end

-- ====================================================================================--

function c.IsNear(arrays)
    local dstchecked = 1000
    local plyPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
	for i = 1, #arrays do
		local array = arrays[i]
		local comparedst = Vdist(plyPos.x, plyPos.y, plyPos.z, array[1], array[2], array[3])
		if comparedst < dstchecked then
			dstchecked = comparedst
		end

		if comparedst < 5.0 then
			DrawMarker(27, array[1], array[2], array[3], 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.7001, 0, 55, 240, 20, 0, 0, 0, 0)
		end
	end
	return dstchecked
end

-- @coords - the {x,y,z}
-- @radius - the distance around.
-- returns table{players}
function c.GetPlayersInArea(coords, radius)
    local peds = GetGamePool('CPed')
    local players = {}
    for _, v in pairs(peds) do
        if IsPedAPlayer(v) then
            local targetCoords = GetEntityCoords(v)
            local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) -
                                 vector3(coords.x, coords.y, coords.z))
            if distance <= radius then
                table.insert(players, v)
            end
        else
            -- not a player
        end
    end
    return players
end

-- @coords - the {x,y,z}
-- @radius - the distance around.
-- returns table{pedsinarea}
function c.GetPedsInArea(coords, radius)
    local peds = GetGamePool('CPed')
    local pedsinarea = {}
    for _, v in pairs(peds) do
        local targetCoords = GetEntityCoords(v)
        local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) -
                             vector3(coords.x, coords.y, coords.z))
        if distance <= radius then
            table.insert(pedsinarea, v)
        end
    end
    return pedsinarea
end

-- @coords - the {x,y,z}
-- @radius - the distance around.
-- returns table{objinarea}
function c.GetObjectsInArea(coords, radius)
    local objs = GetGamePool('CObject')
    local objinarea = {}
    for _, v in pairs(objs) do
        local targetCoords = GetEntityCoords(v)
        local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) -
                             vector3(coords.x, coords.y, coords.z))
        if distance <= radius then
            table.insert(objinarea, v)
        end
    end
    return objinarea
end

-- @coords - the {x,y,z}
-- @radius - the distance around.
-- returns table{vehinarea}
function c.GetVehiclesInArea(coords, radius)
    local vehicles = GetGamePool('CVehicle')
    local vehinarea = {}
    for _, v in pairs(vehicles) do
        local targetCoords = GetEntityCoords(v)
        local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) -
                             vector3(coords.x, coords.y, coords.z))
        if distance <= radius then
            table.insert(vehinarea, v)
        end
    end
    return vehinarea
end

-- @coords - the {x,y,z}
-- @radius - the distance around.
-- returns table{pickinarea}
function c.GetPickupssInArea(coords, radius)
    local pickups = GetGamePool('CPickup')
    local pickinarea = {}
    for _, v in pairs(pickups) do
        local targetCoords = GetEntityCoords(v)
        local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) -
                             vector3(coords.x, coords.y, coords.z))
        if distance <= radius then
            table.insert(pickinarea, v)
        end
    end
    return pickinarea
end

-- returns closestPlayer, closestDistance
function c.GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    for _, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if (target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value))
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) -
                                 vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if (closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

-- returns closestVeh, closestDistance
function c.GetClosestVehicle()
    local closestDistance = -1
    local closestVeh = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    local vehicles = c.GetVehiclesInArea(plyCoords, 6.5)
    for _, value in ipairs(vehicles) do
        local targetCoords = GetEntityCoords(GetPlayerPed(value))
        local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) -
                             vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if (closestDistance == -1 or closestDistance > distance) then
            closestVeh = value
            closestDistance = distance
        end
    end
    return closestVeh, closestDistance
end

function c.GetVehicleInDirection()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    if hit == 1 and GetEntityType(entityHit) == 2 then
        return entityHit
    end
    return nil
end

function c.GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local extras = {}

        for extraId = 0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end

        return {
            model = GetEntityModel(vehicle),

            plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

            bodyHealth = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
            engineHealth = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),
            tankHealth = ESX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),

            fuelLevel = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
            dirtLevel = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
            color1 = colorPrimary,
            color2 = colorSecondary,

            pearlescentColor = pearlescentColor,
            wheelColor = wheelColor,

            wheels = GetVehicleWheelType(vehicle),
            windowTint = GetVehicleWindowTint(vehicle),
            xenonColor = GetVehicleXenonLightsColour(vehicle),

            neonEnabled = {IsVehicleNeonLightEnabled(vehicle, 0), IsVehicleNeonLightEnabled(vehicle, 1),
                           IsVehicleNeonLightEnabled(vehicle, 2), IsVehicleNeonLightEnabled(vehicle, 3)},

            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),

            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),

            modTurbo = IsToggleModOn(vehicle, 18),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modXenon = IsToggleModOn(vehicle, 22),

            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),

            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modLivery = GetVehicleLivery(vehicle)
        }
    else
        return
    end
end

function c.SetVehicleProperties(vehicle, props)
    if DoesEntityExist(vehicle) then
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleModKit(vehicle, 0)

        if props.plate then
            SetVehicleNumberPlateText(vehicle, props.plate)
        end
        if props.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
        end
        if props.bodyHealth then
            SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
        end
        if props.engineHealth then
            SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
        end
        if props.tankHealth then
            SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
        end
        if props.fuelLevel then
            SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
        end
        if props.dirtLevel then
            SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
        end
        if props.color1 then
            SetVehicleColours(vehicle, props.color1, colorSecondary)
        end
        if props.color2 then
            SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
        end
        if props.pearlescentColor then
            SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
        end
        if props.wheelColor then
            SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
        end
        if props.wheels then
            SetVehicleWheelType(vehicle, props.wheels)
        end
        if props.windowTint then
            SetVehicleWindowTint(vehicle, props.windowTint)
        end

        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end

        if props.extras then
            for extraId, enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(extraId), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(extraId), 1)
                end
            end
        end

        if props.neonColor then
            SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
        end
        if props.xenonColor then
            SetVehicleXenonLightsColour(vehicle, props.xenonColor)
        end
        if props.modSmokeEnabled then
            ToggleVehicleMod(vehicle, 20, true)
        end
        if props.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end
        if props.modSpoilers then
            SetVehicleMod(vehicle, 0, props.modSpoilers, false)
        end
        if props.modFrontBumper then
            SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
        end
        if props.modRearBumper then
            SetVehicleMod(vehicle, 2, props.modRearBumper, false)
        end
        if props.modSideSkirt then
            SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
        end
        if props.modExhaust then
            SetVehicleMod(vehicle, 4, props.modExhaust, false)
        end
        if props.modFrame then
            SetVehicleMod(vehicle, 5, props.modFrame, false)
        end
        if props.modGrille then
            SetVehicleMod(vehicle, 6, props.modGrille, false)
        end
        if props.modHood then
            SetVehicleMod(vehicle, 7, props.modHood, false)
        end
        if props.modFender then
            SetVehicleMod(vehicle, 8, props.modFender, false)
        end
        if props.modRightFender then
            SetVehicleMod(vehicle, 9, props.modRightFender, false)
        end
        if props.modRoof then
            SetVehicleMod(vehicle, 10, props.modRoof, false)
        end
        if props.modEngine then
            SetVehicleMod(vehicle, 11, props.modEngine, false)
        end
        if props.modBrakes then
            SetVehicleMod(vehicle, 12, props.modBrakes, false)
        end
        if props.modTransmission then
            SetVehicleMod(vehicle, 13, props.modTransmission, false)
        end
        if props.modHorns then
            SetVehicleMod(vehicle, 14, props.modHorns, false)
        end
        if props.modSuspension then
            SetVehicleMod(vehicle, 15, props.modSuspension, false)
        end
        if props.modArmor then
            SetVehicleMod(vehicle, 16, props.modArmor, false)
        end
        if props.modTurbo then
            ToggleVehicleMod(vehicle, 18, props.modTurbo)
        end
        if props.modXenon then
            ToggleVehicleMod(vehicle, 22, props.modXenon)
        end
        if props.modFrontWheels then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
        end
        if props.modBackWheels then
            SetVehicleMod(vehicle, 24, props.modBackWheels, false)
        end
        if props.modPlateHolder then
            SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
        end
        if props.modVanityPlate then
            SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
        end
        if props.modTrimA then
            SetVehicleMod(vehicle, 27, props.modTrimA, false)
        end
        if props.modOrnaments then
            SetVehicleMod(vehicle, 28, props.modOrnaments, false)
        end
        if props.modDashboard then
            SetVehicleMod(vehicle, 29, props.modDashboard, false)
        end
        if props.modDial then
            SetVehicleMod(vehicle, 30, props.modDial, false)
        end
        if props.modDoorSpeaker then
            SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
        end
        if props.modSeats then
            SetVehicleMod(vehicle, 32, props.modSeats, false)
        end
        if props.modSteeringWheel then
            SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
        end
        if props.modShifterLeavers then
            SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
        end
        if props.modAPlate then
            SetVehicleMod(vehicle, 35, props.modAPlate, false)
        end
        if props.modSpeakers then
            SetVehicleMod(vehicle, 36, props.modSpeakers, false)
        end
        if props.modTrunk then
            SetVehicleMod(vehicle, 37, props.modTrunk, false)
        end
        if props.modHydrolic then
            SetVehicleMod(vehicle, 38, props.modHydrolic, false)
        end
        if props.modEngineBlock then
            SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
        end
        if props.modAirFilter then
            SetVehicleMod(vehicle, 40, props.modAirFilter, false)
        end
        if props.modStruts then
            SetVehicleMod(vehicle, 41, props.modStruts, false)
        end
        if props.modArchCover then
            SetVehicleMod(vehicle, 42, props.modArchCover, false)
        end
        if props.modAerials then
            SetVehicleMod(vehicle, 43, props.modAerials, false)
        end
        if props.modTrimB then
            SetVehicleMod(vehicle, 44, props.modTrimB, false)
        end
        if props.modTank then
            SetVehicleMod(vehicle, 45, props.modTank, false)
        end
        if props.modWindows then
            SetVehicleMod(vehicle, 46, props.modWindows, false)
        end

        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end
    end
end

function c.GetEntityStateBag(entity)
    return Entity(entity).state
end
