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

local hours = {
    _min = 0,
    _max = 23,
}

function c.time.Update()
    local t = os.date('*t')
    SetConvarReplicated('Time', string.format('%02d:%02d', c.time.AlterTime(t.hour), t.min))
    SetConvarServerInfo('Server Time', string.format('%02d:%02d', t.hour, t.min))
end

function c.time.ServerSync()
    local function Do()
        c.time.Update()
        SetTimeout(c.min, Do)
    end
    SetTimeout(c.min, Do)
end

function c.time.AlterTime(h)
    local timealter = conf.timealter
    if timealter <= -23 then timealter = -23 end
    if timealter >= 23 then timealter = 23 end
    local newhour = h - timealter
    if newhour <= hours._min then
        newhour = (hours._max - newhour)
    end
    if newhour >= hours._max then
        newhour = hours._min + (newhour - hours._max)
    end
    return newhour
end

