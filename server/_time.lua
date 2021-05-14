-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.time = {} -- functions
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
    SetConvarReplicated('Time', string.format('%02d:%02d', t.hour, t.min))
    SetConvarServerInfo('Server Time', string.format('%02d:%02d', t.hour, t.min))
end

function c.time.ServerSync()
    local function Do()
        c.time.Update()
        SetTimeout(c.min, Do)
    end
    SetTimeout(c.min, Do)
end
