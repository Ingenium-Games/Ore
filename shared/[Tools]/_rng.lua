-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
_c.rng = {}
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(_c.seed)
-- ====================================================================================--

function _c.rng.num()
    local rand = math.random(0, 9)
    return rand
end

function _c.rng.let()
    local rand = string.char(math.random(97, 122))
    return rand
end

function _c.rng.char()
    local rand = nil
    local rlet = _c.rng.let()
    local rnum = _c.rng.num()
    if math.random(0, 9) > 4 then
        rand = rnum
    else
        rand = rlet
    end
    return rand
end

function _c.rng.nums(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, _c.rng.num())
            else
                table.insert(temp, _c.rng.num())
            end
        end

        rand = tostring(table.concat(temp))
    end
    return rand
end

function _c.rng.lets(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, _c.rng.let())
            else
                table.insert(temp, _c.rng.let())
            end
        end
        rand = tostring(table.concat(temp))
    end
    return rand
end

function _c.rng.chars(num)
    local rand = nil
    local len = num
    local temp = {}
    if rand == nil then
        for i = 1, len do
            if math.random(0, 9) > 4 then
                table.insert(temp, _c.rng.char())
            else
                table.insert(temp, _c.rng.char())
            end
        end
        rand = tostring(table.concat(temp))
    end
    return rand
end

-- ====================================================================================--
