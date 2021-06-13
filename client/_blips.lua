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

Blip = function(x,y,z,sprite,color,text,scale,display,shortRange,highDetail)
    local blip = AddBlipForCoord((x or 0.0),(y or 0.0),(z or 0.0))
    SetBlipSprite               (blip, (sprite or 1))
    SetBlipDisplay              (blip, (display or 3))
    SetBlipScale                (blip, (scale or 1.0))
    SetBlipColour               (blip, (color or 4))
    SetBlipAsShortRange         (blip, (shortRange or false))
    SetBlipHighDetail           (blip, (highDetail or true))
    BeginTextCommandSetBlipName ("STRING")
    AddTextComponentString      ((text or "Blip "..tostring(blip)))
    EndTextCommandSetBlipName   (blip)
  
    return {
      handle = blip,
      x = (x or 0.0),
      y = (y or 0.0),
      z = (z or 0.0),
      sprite = (sprite or 1),
      display = (display or 3),
      scale = (scale or 1.0),
      color = (color or 4),
      shortRange = (shortRange or false),
      highDetail = (highDetail or true),
      text = (text or "Blip "..tostring(blip)),
      pos = vector3((x or 0.0),(y or 0.0),(z or 0.0))
    }
  end
  
  RadiusBlip = function(x,y,z,range,color,alpha,highDetail)
    local blip = AddBlipForRadius((x or 0.0),(y or 0.0),(z or 0.0),(range or 100.0))
    SetBlipColour(blip, (color or 1))
    SetBlipAlpha (blip, (alpha or 80))
    SetBlipHighDetail(blip, (highDetail or true))
  
    return {
      handle = blip,
      x = (x or 0.0),
      y = (y or 0.0),
      z = (z or 0.0),
      range = (range or 100.0),
      color = (color or 1),
      alpha = (alpha or 80),
      highDetail = (highDetail or true),
      pos = vector3((x or 0.0),(y or 0.0),(z or 0.0))
    }
  end
  
  AreaBlip = function(x,y,z,width,height,heading,color,alpha,highDetail,display,shortRange)
    local blip = AddBlipForArea((x or 0.0),(y or 0.0),(z or 0.0),(width or 100.0),(height or 100.0))
    SetBlipColour(blip, (color or 1))
    SetBlipAlpha (blip, (alpha or 80))
    SetBlipHighDetail(blip, (highDetail or true))
    SetBlipRotation(blip, (heading or 0.0))
    SetBlipDisplay(blip, (display or 4))
    SetBlipAsShortRange(blip, (shortRange or true))
  
    return {
      handle = blip,
      x = (x or 0.0),
      y = (y or 0.0),
      z = (z or 0.0),
      width = (width or 100.0),
      display = (display or 4),
      height = (height or 100.0),
      heading = (heading or 0.0),
      color = (color or 1),
      alpha = (alpha or 80),
      highDetail = (highDetail or true),
      pos = vector3((x or 0.0),(y or 0.0),(z or 0.0))
    }
  end

  local blips = {}

local actions = {
  alpha = SetBlipAlpha,
  color = SetBlipColour,
  scale = SetBlipScale,
}

exports('AddBlip', function(...)
  local handle = #blips+1
  local blip = Blip(...)
  blips[handle] = blip
  return handle
end)

exports('AddRadiusBlip', function(...)
  local handle = #blips+1
  local blip = RadiusBlip(...)
  blips[handle] = blip
  return handle
end)

exports('AddAreaBlip', function(...)
  local handle = #blips+1
  local blip = AreaBlip(...)
  blips[handle] = blip
  return handle
end)

exports('GetBlip', function(handle)
  return blips[handle]
end)

exports('SetBlip', function(handle,key,val)  
  local blip = blips[handle]
  blip[key] = val
  if actions[key] then actions[key](blip["handle"],val); end 
end)

exports('RemoveBlip', function(handle)
  local blip = blips[handle]
  if blip then
    RemoveBlip(blip["handle"])
  end
end)

exports('TeleportToBlip', function(handle)
  local blip = blips[handle]
  if blip then
    TeleportPlayer(blip.pos)
  end
end)