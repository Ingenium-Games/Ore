-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.inst = {}
--[[
NOTES.
    -
    -
    -
]]--
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
    local current = GetPlayerRoutingBucket(source)
    if current ~= num then
        -- to add mumble changes based on either pmavoice or frazzles mumble script
        SetPlayerRoutingBucket(source, num)
        SetEntityRoutingBucket(GetPlayerPed(source), num)
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
    -- to add mumble changes based on either pmavoice or frazzles mumble script
    SetPlayerRoutingBucket(source, conf.instancedefault)
    SetEntityRoutingBucket(GetPlayerPed(source), conf.instancedefault)
end

function c.inst.SetEntityDefault(entity)
    SetEntityRoutingBucket(entity, conf.instancedefault)
end