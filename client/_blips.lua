-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.blips = {}
c.blips.store = {}
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

function c.blips.NewName(t)
    local val
    local find = false
    repeat
        val = c.rng.chars(15)
        if c.blips.store[val] then
            find = true
        else
            table.insert(c.blips.store, val)
            c.blips.store[val] = t
            find = false
        end
    until find == false
    return val
end

--[[ 
if the local blip wants to retain the blips name for any reason..
local BlipStore = {}

local Blips = {
    {title = NAME, coords = {x,y,z}, sprite = 2, colour = 2, size = 0.45}
}
    for _,i in ipairs(Blips) do
        local blip = c.blips.MakeBasic([i].title, [i].coords, [i].sprite, [i].colour, [i].size)
        BlipStore[blip]
    end

    -- otherwise 

    for _,i in ipairs(Blips) do
        c.blips.MakeBasic([i].title, [i].coords, [i].sprite, [i].colour, [i].size)
    end

    -- Now we know the name or at least the coords, if we wanted to alter the blip while within or without zones or space, we can do math with its stored name, or the original script can manipulate it 

]]--

function c.blips.MakeBasic(title, x, y, z, sprite, colour, size)
    local t = {['title'] = title, ['x'] = x, ['y'] = y, ['z'] = z, ['sprite'] = sprite, ['colour'] = colour, ['size'] = size}
    local name = c.blips.NewName(t)
    name = AddBlipForCoord(x, y, z)
    --
    SetBlipSprite(name, sprite)
    SetBlipDisplay(name, 2)
    SetBlipScale(name, size)
    SetBlipColour(name, colour)
    SetBlipAsShortRange(name, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
    EndTextCommandSetBlipName(name)
    return name
end

--[[
category = 
1 = No distance shown in legend
2 = Distance shown in legend
7 = "Other Players" category, also shows distance in legend
10 = "Property" category
11 = "Owned Property" category

display
0 = Doesn't show up, ever, anywhere. 
1 = Doesn't show up, ever, anywhere. 
2 = Shows on both main map and minimap. (Selectable on map) 
3 = Shows on main map only. (Selectable on map) 
4 = Shows on main map only. (Selectable on map) 
5 = Shows on minimap only. 
6 = Shows on both main map and minimap. (Selectable on map) 
7 = Doesn't show up, ever, anywhere. 
8 = Shows on both main map and minimap. (Not selectable on map) 
9 = Shows on minimap only. 
10 = Shows on both main map and minimap. (Not selectable on map) .
]]--

-- str, str, int, table/vector3, num, num, int, int, bool, bool, bool
function c.blips.MakeAdvanced(title, x, y, z, sprite, colour, size, display, category, short, flashes, legend)
    local t = {['title'] = title, ['display'] = display, ['x'] = x, ['y'] = y, ['z'] = z, ['sprite'] = sprite, ['colour'] = colour, ['size'] = size, ['category'] = category, ['short'] = short, ['flashes'] = flashes, ['legend'] = legend}
    local name = c.blips.NewName(t)
    name = AddBlipForCoord(x, y, z)
    --
    SetBlipSprite(name, sprite)
    SetBlipDisplay(name, display)
    SetBlipScale(name, size)
    SetBlipColour(name, colour)
    SetBlipFlashes(flashes)
    if flashes then
        SetBlipFlashInterval(name, 500)
        SetBlipFlashTimer(name, 50000)
    end
    SetBlipCategory(name, category)
    SetBlipAsShortRange(name, short)
    SetBlipHiddenOnLegend(name, legend)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
    EndTextCommandSetBlipName(name)
end

--[[
Test Blips
local Blips = {
    {title = 'NAME 1', x = 500.0, y = 1200.0, z = 35.0, sprite = 211, colour = 2, size = 0.75},
    {title = 'NAME 2', x = 600.0, y = 1300.0, z = 35.0, sprite = 207, colour = 3, size = 0.75},
    {title = 'NAME 3', x = 700.0, y = 1400.0, z = 35.0, sprite = 208, colour = 4, size = 0.75},
    {title = 'NAME 4', x = 800.0, y = 1500.0, z = 35.0, sprite = 209, colour = 5, size = 0.75},
    {title = 'NAME 5', x = 900.0, y = 1600.0, z = 35.0, sprite = 210, colour = 6, size = 0.95, display = 2, category = 2, short = false, flashes = true, legend = false}
}
   
for _,i in ipairs(Blips) do
    if i.display ~= nil then
        local name = c.blips.MakeAdvanced(i.title, i.x, i.y, i.z, i.sprite, i.colour, i.size, i.display, i.category, i.short, i.flashes, i.legend)
    else
        local name = c.blips.MakeBasic(i.title, i.x, i.y, i.z, i.sprite, i.colour, i.size)
    end
end

print(c.table.dump(c.blips.store))
]]--