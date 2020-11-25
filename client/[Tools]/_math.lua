-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
_c.math = {}
--[[
NOTES.
    -
    -
    -
]] --
-- ====================================================================================--

function _c.math.decimals(num, dec)
    local p= 10 ^ dec
    if num ~= nil then
        return math.floor((num * p) + 0.5) / (p)
    else
        return num
    end
end

-- ====================================================================================--