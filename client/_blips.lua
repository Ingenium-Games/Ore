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

--- Generate Blips, based on table passed.
---@param t table "title, coords, sprite, colour, size"
function c.blip.CreateBlips(t)
    local tab = c.check.Table(t)
    for i=1, #tab, 1 do
        local i = tab[i]
        local blip = AddBlipForCoord(i.coords)
        SetBlipSprite(blip, i.sprite)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, i.size)
        SetBlipColour(blip, i.colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(i.title)
        EndTextCommandSetBlipblip(blip)        
    end
end

--- Generate advanced Blip, based on table passed.
---@param t table "title, coords, sprite, colour, size, display, category, short, flashes, legend"
function c.blip.CreateNew(t)
    local tab = c.check.Table(t)
    local blip = AddBlipForCoord(tab.coords)
    SetBlipSprite(blip, tab.sprite)
    SetBlipDisplay(blip, tab.display)
    SetBlipScale(blip, tab.size)
    SetBlipColour(blip, tab.colour)
    SetBlipFlashes(tab.flashes)
    if tab.flashes then
        SetBlipFlashInterval(blip, 500)
        SetBlipFlashTimer(blip, 50000)
    end
    SetBlipCategory(blip, tab.category)
    SetBlipAsShortRange(blip, tab.short)
    SetBlipHiddenOnLegend(blip, tab.legend)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tab.title)
    EndTextCommandSetBlipblip(blip)
end