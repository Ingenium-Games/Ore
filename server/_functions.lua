--====================================================================================--
--  Created by Twiitchter - License at 
--====================================================================================--
_c.seed = (os.time() + tonumber(tostring({}):sub(8)) * math.pi)
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
--====================================================================================--

function _c.identifier(source)
    local src = tonumber(source)
    local id = nil
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(v, conf.identifier) then
            id = v
        end
    end
    return id
end

function _c.identifiers(source)
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

--====================================================================================--

function _c.func(...)
    local arg = {...}
    local status, val = _c.err(unpack(arg))
    return val
end

function _c.err(func, ...)
    local arg = {...}
    return xpcall(function()
        return _c.func(unpack(arg))
    end, function(err)
        return _c.error(err)
    end)
end

function _c.error(err)
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

function _c.debug(str)
    if conf.debug then
        print("   ^7[^6Debug^7]:  ".."==    ", str)
    end
end

-- ====================================================================================--

function _c.enumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function _c.enumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function _c.enumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function _c.enumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end
