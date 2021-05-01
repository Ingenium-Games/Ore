-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.time = {} -- functions
c.times = {
    h = 0,
    m = 0
}
--[[
NOTES.
    -
    -
    -
]]--

math.randomseed(c.Seed)
-- ====================================================================================--

function c.time.Update()
    local t = os.date('*t')
    c.times = {
        h = t.hour,
        m = t.min
    }
    SetConvarServerInfo('Time', string.format('%02d:%02d', c.times.h, c.times.m))
end

function c.time.ServerSync()
    local function Do()
        c.time.Update()
        SetTimeout(c.min, Do)
    end
    SetTimeout(c.min, Do)
end
