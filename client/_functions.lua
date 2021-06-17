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

--- Preduce a Busy Spinner
function c.IsBusy()
    BeginTextCommandBusyspinnerOn('FM_COR_AUTOD')
    EndTextCommandBusyspinnerOn(5)
end

--- Remvoe a Busy Spinner
function c.NotBusy()
    BusyspinnerOff()
    PreloadBusyspinner()
end

--- Produce a Busy Spinner with a "Please Wait"
function c.PleaseWait()
    BeginTextCommandBusyspinnerOn('PM_WAIT')
    EndTextCommandBusyspinnerOn(5)
end

--- Informs the client to Please Wait with a Busy Spinner over a timeframe.
---@param ms number "Milisecons to wait."
function c.IsBusyPleaseWait(ms)
    c.PleaseWait()
    --
    Citizen.Wait(ms)
    --
    c.NotBusy()
end

-- ====================================================================================--

--- Return the Entity's state bag.
---@param entity any "Typically a number or string"
function c.GetEntity(entity)
    return Entity(entity).state
end

-- @entity - the object
-- @arrays - locations in a table format
-- @style - c.SelectMarker() - Pick Marker type.
function c.IsNear(coords, arrays, style)
    local dstchecked = 1000
    local pos = coords
	for i = 1, #arrays do
		local ords = arrays[i]
		local comparedst = Vdist(pos - ords)
		if comparedst < dstchecked then
			dstchecked = comparedst
		end
		if comparedst < 5.0 then
            if style then
                c.marker.SelectMarker(style, ords)
            else
                c.marker.SelectMarker(1, ords)
            end
        end
	end
	return dstchecked
end

--- Returns Players within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.GetPlayersInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool('CPed')
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            if IsPedAPlayer(v) then
                local target = vector3(GetEntityCoords(v))
                local distance = #(target - coords)
                if distance <= radius then
                    table.insert(obj, v)
                end
            end
        end -- {obj,obj,obj}
    else   
        for _, v in pairs(objs) do
            if IsPedAPlayer(v) then
                local model = GetEntityModel(v)
                local target = vector3(GetEntityCoords(v))
                local distance = #(target - coords)
                if distance <= radius then
                    obj[v] = {["model"] = model, ["coords"] = target}
                end   
            end
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns All Peds (including Players) within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.GetPedsInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool('CPed')
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else   
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {["model"] = model, ["coords"] =target}
            end   
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Objects within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.GetObjectsInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool('CObject')
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else   
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {["model"] = model, ["coords"] = target}
            end   
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Vehicles within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.GetVehiclesInArea(ords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool('CVehicle')
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else   
        for _, v in pairs(objs) do
            local model = GetEntityModel(v)
            local target = vector3(GetEntityCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {["model"] = model, ["coords"] = target}
            end      
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
end

--- Returns Pickups within the designated radius.
---@param ords table "Generally a {x,y,z} or vector3"
---@param radius number "Radius to return objects within"
---@param minimal boolean "Return just the found objects or their model and coords as well?"
function c.GetPickupsInArea(coords, radius, minimal)
    local coords = vector3(ords)
    local objs = GetGamePool('CPickup')
    local obj = {}
    if minimal then
        for _, v in pairs(objs) do
            local target = vector3(GetPickupCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                table.insert(obj, v)
            end
        end -- {obj,obj,obj}
    else   
        for _, v in pairs(objs) do
            local model = GetPickupHash(v)
            local target = vector3(GetPickupCoords(v))
            local distance = #(target - coords)
            if distance <= radius then
                obj[v] = {["model"] = model, ["coords"] = target}
            end      
        end -- { [objectID] = {model = XYZ, coords=vec3}, [objectID] = {model = XYZ, coords=vec3} }
    end
    return obj
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

function c.CreateVehicle(model,x,y,z,h)
    local attempt = 0
    local hash = (GetHashKey(model) or model)
    --
    if not IsModelInCdimage(hash) then 
        c.debug("Model / Hash not found: ".. model .. " " ..hash)
        return 
    end
    --
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end
    Citizen.Wait(0)
    --
    local vehicle = CreateVehicle(hash, x, y, z, h, true, true)
    local spawn = SetVehicleOnGroundProperly(vehicle)
    --
    SetEntityAsMissionEntity(vehicle, true, true)
    NetworkEntity(vehicle)
    --
    local net = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdCanMigrate(net)
    --
    return vehicle, net, spawn
end
  
function c.SetVehicleProps(vehicle, props)
    SetVehicleModKit(vehicle, 0)
  
    if props.plate ~= nil then
      SetVehicleNumberPlateText(vehicle, props.plate)
    end
  
    if props.plateIndex ~= nil then
      SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
    end
  
    if props.bodyHealth ~= nil then
      SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
    end
  
    if props.engineHealth ~= nil then
      SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
    end
  
    if props.Fuel ~= nil then
      SetVehicleFuelLevel(vehicle, props.Fuel + 0.0)
    end
  
    if props.dirtLevel ~= nil then
      SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
    end
  
    if props.color1 ~= nil then
      local color1, color2 = GetVehicleColours(vehicle)
      SetVehicleColours(vehicle, props.color1, color2)
    end
  
    if props.color2 ~= nil then
      local color1, color2 = GetVehicleColours(vehicle)
      SetVehicleColours(vehicle, color1, props.color2)
    end
  
    if props.pearlescentColor ~= nil then
      local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
      SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
    end
  
    if props.wheelColor ~= nil then
      local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
      SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
    end
  
    if props.wheels ~= nil then
      SetVehicleWheelType(vehicle, props.wheels)
    end
  
    if props.windowTint ~= nil then
      SetVehicleWindowTint(vehicle, props.windowTint)
    end
  
    if props.neonEnabled ~= nil then
      SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
      SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
      SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
      SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
    end
  
    if props.extras ~= nil then
      for id,enabled in pairs(props.extras) do
        if enabled then
          SetVehicleExtra(vehicle, tonumber(id), 0)
        else
          SetVehicleExtra(vehicle, tonumber(id), 1)
        end
      end
    end
  
    if props.neonColor ~= nil then
      SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
    end
  
    if props.modSmokeEnabled ~= nil then
      ToggleVehicleMod(vehicle, 20, true)
    end
  
    if props.tyreSmokeColor ~= nil then
      SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
    end
  
    if props.modSpoilers ~= nil then
      SetVehicleMod(vehicle, 0, props.modSpoilers, false)
    end
  
    if props.modFrontBumper ~= nil then
      SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
    end
  
    if props.modRearBumper ~= nil then
      SetVehicleMod(vehicle, 2, props.modRearBumper, false)
    end
  
    if props.modSideSkirt ~= nil then
      SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
    end
  
    if props.modExhaust ~= nil then
      SetVehicleMod(vehicle, 4, props.modExhaust, false)
    end
  
    if props.modFrame ~= nil then
      SetVehicleMod(vehicle, 5, props.modFrame, false)
    end
  
    if props.modGrille ~= nil then
      SetVehicleMod(vehicle, 6, props.modGrille, false)
    end
  
    if props.modHood ~= nil then
      SetVehicleMod(vehicle, 7, props.modHood, false)
    end
  
    if props.modFender ~= nil then
      SetVehicleMod(vehicle, 8, props.modFender, false)
    end
  
    if props.modRightFender ~= nil then
      SetVehicleMod(vehicle, 9, props.modRightFender, false)
    end
  
    if props.modRoof ~= nil then
      SetVehicleMod(vehicle, 10, props.modRoof, false)
    end
  
    if props.modEngine ~= nil then
      SetVehicleMod(vehicle, 11, props.modEngine, false)
    end
  
    if props.modBrakes ~= nil then
      SetVehicleMod(vehicle, 12, props.modBrakes, false)
    end
  
    if props.modTransmission ~= nil then
      SetVehicleMod(vehicle, 13, props.modTransmission, false)
    end
  
    if props.modHorns ~= nil then
      SetVehicleMod(vehicle, 14, props.modHorns, false)
    end
  
    if props.modSuspension ~= nil then
      SetVehicleMod(vehicle, 15, props.modSuspension, false)
    end
  
    if props.modArmor ~= nil then
      SetVehicleMod(vehicle, 16, props.modArmor, false)
    end
  
    if props.modTurbo ~= nil then
      ToggleVehicleMod(vehicle,  18, props.modTurbo)
    end
  
    if props.modXenon ~= nil then
      ToggleVehicleMod(vehicle,  22, props.modXenon)
    end
  
    if props.modFrontWheels ~= nil then
      SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
    end
  
    if props.modBackWheels ~= nil then
      SetVehicleMod(vehicle, 24, props.modBackWheels, false)
    end
  
    if props.modPlateHolder ~= nil then
      SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
    end
  
    if props.modVanityPlate ~= nil then
      SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
    end
  
    if props.modTrimA ~= nil then
      SetVehicleMod(vehicle, 27, props.modTrimA, false)
    end
  
    if props.modOrnaments ~= nil then
      SetVehicleMod(vehicle, 28, props.modOrnaments, false)
    end
  
    if props.modDashboard ~= nil then
      SetVehicleMod(vehicle, 29, props.modDashboard, false)
    end
  
    if props.modDial ~= nil then
      SetVehicleMod(vehicle, 30, props.modDial, false)
    end
  
    if props.modDoorSpeaker ~= nil then
      SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
    end
  
    if props.modSeats ~= nil then
      SetVehicleMod(vehicle, 32, props.modSeats, false)
    end
  
    if props.modSteeringWheel ~= nil then
      SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
    end
  
    if props.modShifterLeavers ~= nil then
      SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
    end
  
    if props.modAPlate ~= nil then
      SetVehicleMod(vehicle, 35, props.modAPlate, false)
    end
  
    if props.modSpeakers ~= nil then
      SetVehicleMod(vehicle, 36, props.modSpeakers, false)
    end
  
    if props.modTrunk ~= nil then
      SetVehicleMod(vehicle, 37, props.modTrunk, false)
    end
  
    if props.modHydrolic ~= nil then
      SetVehicleMod(vehicle, 38, props.modHydrolic, false)
    end
  
    if props.modEngineBlock ~= nil then
      SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
    end
  
    if props.modAirFilter ~= nil then
      SetVehicleMod(vehicle, 40, props.modAirFilter, false)
    end
  
    if props.modStruts ~= nil then
      SetVehicleMod(vehicle, 41, props.modStruts, false)
    end
  
    if props.modArchCover ~= nil then
      SetVehicleMod(vehicle, 42, props.modArchCover, false)
    end
  
    if props.modAerials ~= nil then
      SetVehicleMod(vehicle, 43, props.modAerials, false)
    end
  
    if props.modTrimB ~= nil then
      SetVehicleMod(vehicle, 44, props.modTrimB, false)
    end
  
    if props.modTank ~= nil then
      SetVehicleMod(vehicle, 45, props.modTank, false)
    end
  
    if props.modWindows ~= nil then
      SetVehicleMod(vehicle, 46, props.modWindows, false)
    end
  
    if props.modLivery ~= nil then
      SetVehicleMod(vehicle, 48, props.modLivery, false)
      SetVehicleLivery(vehicle, props.modLivery)
    end
  end
  
function c.GetVehicleModifications(vehicle)
    local color1, color2 = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local extras = {}
  
    for id=0, 64 do
      if DoesExtraExist(vehicle, id) then
        local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
        extras[tostring(id)] = state
      end
    end
  
    return {
      model             = GetEntityModel(vehicle),
  
      plate             = GetVehicleNumberPlateText(vehicle),
      plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
  
      bodyHealth        = math.ceil(GetVehicleBodyHealth(vehicle), 1),
      engineHealth      = math.ceil(GetVehicleEngineHealth(vehicle), 1),
  
      Fuel              = math.ceil(GetVehicleFuelLevel(vehicle), 1),
      dirtLevel         = math.ceil(GetVehicleDirtLevel(vehicle), 1),
      color1            = color1,
      color2            = color2,
  
      pearlescentColor  = pearlescentColor,
      wheelColor        = wheelColor,
  
      wheels            = GetVehicleWheelType(vehicle),
      windowTint        = GetVehicleWindowTint(vehicle),
  
      neonEnabled       = {
        IsVehicleNeonLightEnabled(vehicle, 0),
        IsVehicleNeonLightEnabled(vehicle, 1),
        IsVehicleNeonLightEnabled(vehicle, 2),
        IsVehicleNeonLightEnabled(vehicle, 3)
      },
  
      extras            = extras,
  
      neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
      tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),
  
      modSpoilers       = GetVehicleMod(vehicle, 0),
      modFrontBumper    = GetVehicleMod(vehicle, 1),
      modRearBumper     = GetVehicleMod(vehicle, 2),
      modSideSkirt      = GetVehicleMod(vehicle, 3),
      modExhaust        = GetVehicleMod(vehicle, 4),
      modFrame          = GetVehicleMod(vehicle, 5),
      modGrille         = GetVehicleMod(vehicle, 6),
      modHood           = GetVehicleMod(vehicle, 7),
      modFender         = GetVehicleMod(vehicle, 8),
      modRightFender    = GetVehicleMod(vehicle, 9),
      modRoof           = GetVehicleMod(vehicle, 10),
  
      modEngine         = GetVehicleMod(vehicle, 11),
      modBrakes         = GetVehicleMod(vehicle, 12),
      modTransmission   = GetVehicleMod(vehicle, 13),
      modHorns          = GetVehicleMod(vehicle, 14),
      modSuspension     = GetVehicleMod(vehicle, 15),
      modArmor          = GetVehicleMod(vehicle, 16),
  
      modTurbo          = IsToggleModOn(vehicle, 18),
      modSmokeEnabled   = IsToggleModOn(vehicle, 20),
      modXenon          = IsToggleModOn(vehicle, 22),
  
      modFrontWheels    = GetVehicleMod(vehicle, 23),
      modBackWheels     = GetVehicleMod(vehicle, 24),
  
      modPlateHolder    = GetVehicleMod(vehicle, 25),
      modVanityPlate    = GetVehicleMod(vehicle, 26),
      modTrimA          = GetVehicleMod(vehicle, 27),
      modOrnaments      = GetVehicleMod(vehicle, 28),
      modDashboard      = GetVehicleMod(vehicle, 29),
      modDial           = GetVehicleMod(vehicle, 30),
      modDoorSpeaker    = GetVehicleMod(vehicle, 31),
      modSeats          = GetVehicleMod(vehicle, 32),
      modSteeringWheel  = GetVehicleMod(vehicle, 33),
      modShifterLeavers = GetVehicleMod(vehicle, 34),
      modAPlate         = GetVehicleMod(vehicle, 35),
      modSpeakers       = GetVehicleMod(vehicle, 36),
      modTrunk          = GetVehicleMod(vehicle, 37),
      modHydrolic       = GetVehicleMod(vehicle, 38),
      modEngineBlock    = GetVehicleMod(vehicle, 39),
      modAirFilter      = GetVehicleMod(vehicle, 40),
      modStruts         = GetVehicleMod(vehicle, 41),
      modArchCover      = GetVehicleMod(vehicle, 42),
      modAerials        = GetVehicleMod(vehicle, 43),
      modTrimB          = GetVehicleMod(vehicle, 44),
      modTank           = GetVehicleMod(vehicle, 45),
      modWindows        = GetVehicleMod(vehicle, 46),
      modLivery         = GetVehicleLivery(vehicle)
    }
  end

function c.GetVehicleCondition(vehicle)
  local eng = GetVehicleEngineHealth(vehicle)
  local tank = GetVehiclePetrolTankHealth(vehicle)
  local body = GetVehicleBodyHealth(vehicle)
  local numwheels = GetVehicleNumberOfWheels(vehicle)
  local wheels = {}
  for i=1, numwheels, 0 do
    wheels[i] = {
      ['ConBurst'] = IsVehicleTyreBurst(vehicle, i, false),
      ['ConGone'] = DoesVehicleTyreExist(vehicle, i),
      ['ConTyre'] = GetTyreHealth(vehicle, i),
      ['ConWheel'] = GetVehicleWheelHealth(vehicle, i),
    }
  end
  local numdoors = GetNumberOfVehicleDoors(vehicle)
  local doors = {}
  for i=1, numdoors, 0 do
    doors[i] = {
      ['ConValid'] = GetIsDoorValid(vehicle, i),
      ['ConDamaged'] = IsVehicleDoorDamaged(vehicle, i),
    }
  end
  --
  return {
    ['ConWheels'] = wheels,
    ['ConDoors'] = doors,
    ['ConEng'] = eng,
    ['ConTank'] = tank,
    ['ConBody'] = body,
  }
end

function c.SetVehicleCondition(vehicle, cons)
  
  if cons.ConEng ~= nil then
    SetVehicleEngineHealth(vehicle, cons.ConEng)
  end
  
  if cons.ConTank ~= nil then
    SetVehiclePetrolTankHealth(vehicle, cons.ConTank)
  end
  
  if cons.ConBody ~= nil then
    SetVehicleBodyHealth(vehicle, cons.ConBody)
  end
  
  if cons.ConWheels ~= nil then
    for i=1, #cons.ConWheels, 0 do
      if cons.ConWheels[i]['ConGone'] then
        SetVehicleTyreBurst(vehicle, i, true, 1000.0)
      end
      if cons.ConWheels[i]['ConBurst'] then
        SetVehicleTyreBurst(vehicle, i, false, 250.0)
      end
      SetVehicleWheelHealth(vehicle, i, cons.ConWheels[i]['ConWheel'])
      SetTyreHealth(vehicle, i, cons.ConWheels[i]['ConTyre'])
      if not cons.ConWheels[i]['ConBurst'] and not cons.ConWheels[i]['ConGone'] then
        SetVehicleTyreFixed(vehicle, i)
      end
    end
  end

  if cons.ConDoors ~= nil then
    for i=1, #cons.ConDoors, 0 do
      local a,b = cons.ConDoors[i]['ConValid'], cons.ConDoors[i]['ConDamaged']
      if a and b then
        SetVehicleDoorBroken(vehicle, i, true)
      elseif a or b then
        SetVehicleDoorBroken(vehicle, i, false)
      end
    end
  end

end















  Scaleforms = {}

-- Load scaleforms
Scaleforms.LoadMovie = function(name)
  local scaleform = RequestScaleformMovie(name)
  while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
  return scaleform
end

Scaleforms.LoadInteractive = function(name)
  local scaleform = RequestScaleformMovieInteractive(name)
  while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
  return scaleform
end

Scaleforms.UnloadMovie = function(scaleform)
  SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-- Text & labels
Scaleforms.LoadAdditionalText = function(gxt,count)
  for i=0,count,1 do
    if not HasThisAdditionalTextLoaded(gxt,i) then
      ClearAdditionalText(i, true)
      RequestAdditionalText(gxt, i)
      while not HasThisAdditionalTextLoaded(gxt,i) do Wait(0); end
    end
  end
end

Scaleforms.SetLabels = function(scaleform,labels)
  PushScaleformMovieFunction(scaleform, "SET_LABELS")
  for i=1,#labels,1 do
    local txt = labels[i]
    BeginTextCommandScaleformString(txt)
    EndTextCommandScaleformString()
  end
  PopScaleformMovieFunctionVoid()
end

-- Push method vals wrappers
Scaleforms.PopMulti = function(scaleform,method,...)
  PushScaleformMovieFunction(scaleform,method)
  for _,v in pairs({...}) do
    local trueType = Scaleforms.TrueType(v)
    if trueType == "string" then      
      PushScaleformMovieFunctionParameterString(v)
    elseif trueType == "boolean" then
      PushScaleformMovieFunctionParameterBool(v)
    elseif trueType == "int" then
      PushScaleformMovieFunctionParameterInt(v)
    elseif trueType == "float" then
      PushScaleformMovieFunctionParameterFloat(v)
    end
  end
  PopScaleformMovieFunctionVoid()
end

Scaleforms.PopFloat = function(scaleform,method,val)
  PushScaleformMovieFunction(scaleform,method)
  PushScaleformMovieFunctionParameterFloat(val)
  PopScaleformMovieFunctionVoid()
end

Scaleforms.PopInt = function(scaleform,method,val)
  PushScaleformMovieFunction(scaleform,method)
  PushScaleformMovieFunctionParameterInt(val)
  PopScaleformMovieFunctionVoid()
end

Scaleforms.PopBool = function(scaleform,method,val)
  PushScaleformMovieFunction(scaleform,method)
  PushScaleformMovieFunctionParameterBool(val)
  PopScaleformMovieFunctionVoid()
end

-- Push no args
Scaleforms.PopRet = function(scaleform,method)                
  PushScaleformMovieFunction(scaleform, method)
  return PopScaleformMovieFunction()
end

Scaleforms.PopVoid = function(scaleform,method)
  PushScaleformMovieFunction(scaleform, method)
  PopScaleformMovieFunctionVoid()
end

-- Get return
Scaleforms.RetBool = function(ret)
  return GetScaleformMovieFunctionReturnBool(ret)
end

Scaleforms.RetInt = function(ret)
  return GetScaleformMovieFunctionReturnInt(ret)
end

-- Util functions
Scaleforms.TrueType = function(val)
  if type(val) ~= "number" then return type(val); end

  local s = tostring(val)
  if string.find(s,'.') then 
    return "float"
  else
    return "int"
  end
end

GetKeyHeld = function(key)
    return (IsControlPressed(0,key) or IsDisabledControlPressed(0,key))
  end
  
  GetKeyDown = function(key)
    return (IsControlJustPressed(0,key) or IsDisabledControlJustPressed(0,key))
  end
  
  GetKeyUp = function(key)
    return (IsControlJustReleased(0,key) or IsDisabledControlJustReleased(0,key))
  end