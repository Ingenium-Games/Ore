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

--- func desc
function c.time.Update()
    local t = os.date('*t')
    local newt = c.time.AlterTime(t.hour)
    SetConvarReplicated('Time', string.format('%02d:%02d', newt, t.min))
    SetConvarServerInfo('Server Time', string.format('%02d:%02d', t.hour, t.min))
    -- Add Cron Handler into the Time Functions.
    c.cron.Action(newt, t.min)
end

--- func desc
function c.time.ServerSync()
    c.time.Update()
    local function Do()
        c.time.Update()
        SetTimeout(c.min, Do)
    end
    SetTimeout(c.min, Do)
end

--- func desc
---@param h number "Can do any, but really only 0,23 will work."
function c.time.AlterTime(h)
    local timealter = conf.altertime
    if timealter <= -23 then timealter = -23 end
    if timealter >= 23 then timealter = 23 end
    local newhour = h + timealter
    if newhour <= hours._min then
        newhour = (hours._max - newhour)
    end
    if newhour >= hours._max then
        newhour = hours._min + (newhour - hours._max)
    end
    return newhour
end