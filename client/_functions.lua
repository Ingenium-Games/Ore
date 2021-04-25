-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.seed)
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
    Citizen.Wait(ms)
    c.NotBusy()
    --
    if cb then
        cb()
    end
end