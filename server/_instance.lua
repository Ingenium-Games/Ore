-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.inst = {}
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--
local count = 1

function c.inst.New()
    if count <= 63 then
        count = count + 1
        return count
    else
        count = 1
        count = count + 1
        return count
    end
end

function c.inst.SetPlayer(source, num)
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(source)
    local current = GetPlayerRoutingBucket(source)
    if current ~= num then
        -- to add mumble changes based on either pmavoice or frazzles mumble script
        SetPlayerRoutingBucket(source, num)
        SetEntityRoutingBucket(GetPlayerPed(source), num)
        xPlayer.SetInstance(num)
        c.sql.SetCharacterInstance(xPlayer.GetIdentifier(), num, c.debug(xPlayer.Name.." added to Instance: "..num))
    end
end

function c.inst.SetEntity(entity, num)
    local current = GetEntityRoutingBucket(entity)
    if current ~= num then
        SetEntityRoutingBucket(entity, num)
    end
end

function c.inst.GetPlayerInstance(source)
    return GetPlayerRoutingBucket(source)
end

function c.inst.GetEntityInstance(entity)
    return GetEntityRoutingBucket(entity)
end

function c.inst.SetPlayerDefault(source)
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(source)
    SetPlayerRoutingBucket(source, conf.instancedefault)
    SetEntityRoutingBucket(GetPlayerPed(source), conf.instancedefault)
    xPlayer.SetInstance(conf.instancedefault)
    c.sql.SetCharacterInstance(xPlayer.GetIdentifier(), conf.instancedefault, c.debug(xPlayer.Name.." added to Instance: "..conf.instancedefault))
end

function c.inst.SetEntityDefault(entity)
    SetEntityRoutingBucket(entity, conf.instancedefault)
end

-- only called once client is character ready.
-- check instance on reload of character
AddEventHandler("Server:Character:Ready", function()
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(source)
    SetPlayerRoutingBucket(source, xPlayer.GetInstance())
    SetEntityRoutingBucket(GetPlayerPed(source), xPlayer.GetInstance())
end)