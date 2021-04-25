--====================================================================================--
--  Created by Twiitchter - License at 
--====================================================================================--
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

function c.identifier(source)
    local src = tonumber(source)
    local id = nil
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, conf.identifier) then
            id = v
        end
    end
    return id
end

function c.identifiers(source)
    local src = tonumber(source)
    local steam, fivem, license, discord, ip = nil, nil, nil, nil, nil
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, "steam:") then
            steam = v
        elseif string.match(v, "fivem:") then
            fivem = v
        elseif string.match(v, "license:") then
            license = v
        elseif string.match(v, "discord:") then
            discord = v
        elseif string.match(v, "ip:") then
            ip = v
        end
    end
    return steam, fivem, license, discord, ip
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

RegisterNetEvent('__pmc_callback:server')
AddEventHandler('__pmc_callback:server', function(eventName, ticket, ...)
	local s = source
	local p = promise.new()

	TriggerEvent('s__pmc_callback:'..eventName, function(...)
		p:resolve({...})
	end, s, ...)

	local result = Citizen.Await(p)
	TriggerClientEvent(('__pmc_callback:client:%s:%s'):format(eventName, ticket), s, table.unpack(result))
end)

_G.RegisterServerCallback = function(eventName, fn)
	assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
	assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got '..type(fn))

	AddEventHandler(('s__pmc_callback:%s'):format(eventName), function(cb, s, ...)
		local result = {fn(s, ...)}
		cb(table.unpack(result))
	end)
end

_G.TriggerClientCallback = function(src, eventName, ...)
	assert(type(src) == 'number', 'Invalid Lua type at argument #1, expected number, got '..type(src))
	assert(type(eventName) == 'string', 'Invalid Lua type at argument #2, expected string, got '..type(eventName))

	local p = promise.new()
	
	RegisterNetEvent('__pmc_callback:server:'..eventName)
	local e = AddEventHandler('__pmc_callback:server:'..eventName, function(...)
		local s = source
		if src == s then
			p:resolve({...})
		end
	end)
	
	TriggerClientEvent('__pmc_callback:client', src, eventName, ...)
	
	local result = Citizen.Await(p)
	RemoveEventHandler(e)
	return table.unpack(result)
end

-- ====================================================================================--

