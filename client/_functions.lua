-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
-- ====================================================================================--

function _c.L(k)
    local lang = _c.data.GetLocale()
    if i18n[lang][k] then
        return i18n[lang][k]
    else
        return i18n['en']['missing']
    end
end

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