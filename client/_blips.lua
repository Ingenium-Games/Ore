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

--title, coords, sprite, colour, size
function c.blip.CreateBlips(t)
    local tab = c.check.Table(t)
    local size = c.table.SizeOf(tab)
    --    
    Citizen.CreateThread(function()
        for i=1, size, 1 do
            local i = tab[i]
            local name = ""..tostring(i).."-"..c.rng.chars(5).."-"..c.rng.chars(5)..""
            AddBlipForCoord(i.coords)
            SetBlipSprite(name, i.sprite)
            SetBlipDisplay(name, 2)
            SetBlipScale(name, i.size)
            SetBlipColour(name, i.colour)
            SetBlipAsShortRange(name, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(i.title)
            EndTextCommandSetBlipName(name)        
            c.blips[name] = tab[i]
        end
    end)
end

-- title, coords, sprite, colour, size, display, category, short, flashes, legend
function c.blip.New(t)
    local tab = c.check.Table(t)
    local name = "N-"..c.rng.chars(5).."-"..c.rng.chars(5)..""
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
    c.blips[name] = tab
end
