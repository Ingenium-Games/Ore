-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.table = {}
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

function c.table.matchvalue(t, v)
    for _, i in ipairs(t) do
        if (i == v) then
            return true
        end
    end
    return false
end

function c.table.matchkey(t, k)
    for i, _ in ipairs(t) do
        if (i == k) then
            return true
        end
    end
    return false
end

function c.table.clone(t)
    local u = setmetatable({}, getmetatable(t))
    for i, v in pairs(t) do
        u[i] = v
    end
    return u
end

function c.table.merge(t, u)
    local r = c.table.clone(t)
    for i, v in pairs(u) do
        r[i] = v
    end
    return r
end

function c.table.rearrange(p, t)
    local r = c.table.clone(t)
    for i, v in pairs(p) do
        r[v] = t[i]
        r[i] = nil
    end
    return r
end

function c.table.size(t)
    local r = #t
    return r
end

function c.table.dump(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == 'table' then
        local s = ''
        for i = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = '{\n'
        for k, v in pairs(table) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            for i = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. '[' .. k .. '] = ' .. c.table.dump(v, nb + 1) .. ',\n'
        end

        for i = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. '}'
    else
        return tostring(table)
    end
end

-- ====================================================================================--
