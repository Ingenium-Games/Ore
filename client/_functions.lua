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
-- Variables
c.PlayerLoaded

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
            print("   ^7[^3Error^7]:  ".."==    ", err)
            print(debug.traceback(_, 2))
        else
            print("   ^7[^3Error^7]:  ".."==    ", 'Unable to type(err) == string. [err] = ', err)
            print(debug.traceback(_, 2))
        end
    end
end

function c.debug(str)
    if conf.debug then
        print("   ^7[^6Debug^7]:  ".."==    ", str)
    end
end

-- ====================================================================================--
-- https://forum.cfx.re/t/tutorial-cancellable-function-usage/137558

CancellationToken = { }
CancellationToken.__index = CancellationToken

function CancellationToken.MakeToken(cancellationHandler)
    local self = { }

    setmetatable(self, CancellationToken)
    
    self._cancelled = false

    if cancellationHandler then
        self._cancellationHandler = cancellationHandler
    end
end

function CancellationToken:Cancel()
    if self._cancelled then return end

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
    if token:WasCancelled() then CancelEvent() end
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

_G.TriggerServerCallback = function(eventName, ...)
	assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))

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
	
_G.RegisterClientCallback = function(eventName, fn)
	assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
	assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got '..type(fn))

	AddEventHandler(('c__pmc_callback:%s'):format(eventName), function(cb, ...)
		cb(fn(...))
	end)
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
    Citizen.Wait(ms/2)
	if cb then
        cb()
    end
	Citizen.Wait(ms/2)
	--
    c.NotBusy()
end

-- ====================================================================================--

-- @coords - the {x,y,z}
-- @radius - the distance around.
-- returns table{players}
function c.GetPlayersInArea(coords, radius)
	local peds = GetGamePool('CPed')
	local players = {}
	for _, v in pairs(peds) do
		if IsPedAPlayer(v) then
			local targetCoords = GetEntityCoords(v)
			local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))
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
		local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))
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
		local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))
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
		local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))
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
		local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))
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
	for _,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value))
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end
