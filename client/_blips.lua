-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.blip = {} -- functions
c.blips = {} -- stored made blips.
--[[
NOTES.
    - 
    - 
    -
]] --
math.randomseed(c.Seed)
SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
-- ====================================================================================--
-- https://docs.fivem.net/docs/game-references/blips/
-- https://runtime.fivem.net/doc/natives/?_0x9029B2F3DA924928

function c.blip.NewName(t)
    local val
    local find = false
    repeat
        val = "BLIP-"..c.rng.chars(5).."-"..c.rng.chars(5).."-"..c.rng.chars(5).."-"..c.rng.chars(5)..""
        if c.blips[val] then
            find = true
        else
            c.blips[val] = t
            find = false
        end
    until find == false
    return val
end

--- Generate Blips, based on table passed.
---@param t table "title, coords, sprite, colour, size"
function c.blip.CreateThreadLoop(t)
    local tab = c.check.Table(t)
    Citizen.CreateThread(function()
        for i=1, #tab, 1 do
            local i = tab[i]
            local name = c.blip.NewName(tab)
            AddBlipForCoord(i.coords)
            SetBlipSprite(name, i.sprite)
            SetBlipDisplay(name, 2)
            SetBlipScale(name, i.size)
            SetBlipColour(name, i.colour)
            SetBlipAsShortRange(name, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(i.title)
            EndTextCommandSetBlipName(name)        
        end
    end)
end

--- Generate advanced Blip, based on table passed.
---@param t table "title, coords, sprite, colour, size, display, category, short, flashes, legend"
function c.blip.CreateNew(t)
    local tab = c.check.Table(t)
    local name = c.blip.NewName(tab)
    AddBlipForCoord(tab.coords)
    SetBlipSprite(name, tab.sprite)
    SetBlipDisplay(name, tab.display)
    SetBlipScale(name, tab.size)
    SetBlipColour(name, tab.colour)
    SetBlipFlashes(tab.flashes)
    if tab.flashes then
        SetBlipFlashInterval(name, 500)
        SetBlipFlashTimer(name, 50000)
    end
    SetBlipCategory(name, tab.category)
    SetBlipAsShortRange(name, tab.short)
    SetBlipHiddenOnLegend(name, tab.legend)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tab.title)
    EndTextCommandSetBlipName(name)
end
