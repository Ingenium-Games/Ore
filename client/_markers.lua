-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.marker = {}
c.markers = {}
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--
-- https://docs.fivem.net/docs/game-references/markers/

--[[
Marker = function(type,posX,posY,posZ,dirX,dirY,dirZ,rotX,rotY,rotZ,scaleX,scaleY,scaleZ,red,green,blue,alpha,bobUpAndDown,faceCamera,p19,rotate,textureDict,textureName,drawOnEnts,textDist,text,doFunc,onKey,funcArgs)
    return {
      type = (type or 0),
      posX = (posX or 0.0),
      posY = (posY or 0.0),
      posZ = (posZ or 0.0),
      dirX = (dirX or 0.0),
      dirY = (dirY or 0.0),
      dirZ = (dirZ or 0.0),
      rotX = (rotX or 0.0),
      rotY = (rotY or 0.0),
      rotZ = (rotZ or 0.0),
      scaleX = (scaleX or 0.0),
      scaleY = (scaleY or 0.0),
      scaleZ = (scaleZ or 0.0),
      red = (red or 255),
      green = (green or 255),
      blue = (blue or 255),
      alpha = (alpha or 255),
      bobUpAndDown = (bobUpAndDown or false),
      faceCamera = (faceCamera or true),
      p19 = (p19 or false),
      rotate = (rotate or true),
      textureDict = (textureDict or nil),
      textureName = (textureName or nil),
      drawOnEnts = (drawOnEnts or nil),
      pos = vector3((posX or 0.0),(posY or 0.0),(posZ or 0.0)),
      textDist = (textDist or false),
      text = (text or false),
      doFunc = (doFunc or false),
      onKey = (onKey or false),
      funcArgs = (funcArgs or false),
    }
  end

local markers = {}
local chunk = {}

local lastChunk = false
local chunkDist = 100.0
local drawDist  =  20.0

local ReChunk = function()
  local newChunk = {}
  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)
  for k,v in pairs(markers) do
    local dist = Vdist(pos,v.pos)
    if dist < chunkDist then
      newChunk[#newChunk+1] = v
    end
  end
  return newChunk
end

local RenderMarker = function(marker)
  DrawMarker(marker.type, marker.posX, marker.posY, marker.posZ, marker.dirX, marker.dirY, marker.dirZ, marker.rotX, marker.rotY, marker.rotZ, marker.scaleX, marker.scaleY, marker.scaleZ, marker.red, marker.green, marker.blue, marker.alpha, marker.bobUpAndDown, marker.faceCamera, marker.p19, marker.rotate, marker.textureDict, marker.textureName, marker.drawOnEnts);
end

local DrawMarkers = function()
  local plyPos = PlayerPos()
  for k,v in pairs(chunk) do
    local dist = Vdist(plyPos,v.pos)
    if dist < drawDist then
      RenderMarker(v)
      if v.textDist and v.text then
        if dist < v.textDist then
          HelpNotification(v.text)
          if v.doFunc and v.onKey then
            if IsControlJustReleased(0,v.onKey) or IsDisabledControlJustReleased(0,v.onKey) then
              Wait(0)
              v.doFunc(v.funcArgs)
            end
          end
        end
      end
    end
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local timeNow = GetGameTimer()
    local timer = math.ceil(math.max(1,math.min(10,#markers))*100)
    if (not lastChunk or (timeNow - lastChunk > timer)) then
      lastChunk = timeNow
      chunk = ReChunk()
    end
    Citizen.Wait(1)
    DrawMarkers()
  end
end)

exports('AddMarker',function(...)
  local marker = Marker(...)
  local handle = #markers+1
  markers[handle] = marker
  return handle
end)

exports('RemoveMarker',function(handle)
  local marker = markers[handle]
  if marker then
    for k,v in pairs(chunk) do
      if v == marker then
        chunk[k] = nil
      end
    end
    markers[handle] = nil
  end
end)
]] --

--- Select a premade marker style.
---@param v number "A number to select corresponding local array value."
---@param ords table "a vector3() or {x,y,z}"
function c.marker.SelectMarker(v, ords)
    if type(ords) ~= vector3 then
        local ords = {
            [1] = v.x,
            [2] = v.y,
            [3] = v.z
        }
    end
    if v == 1 then
    -- Blue Static Circle.
    DrawMarker(27, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.7001, 0, 55, 240, 35, 0, 0, 2, 0)
    elseif v == 2 then
      -- Blue Static $.
      DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
    elseif v == 3 then    
      -- Blue Static ?.
      DrawMarker(32, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
          elseif v == 4 then
            -- Blue Static Chevron.
      DrawMarker(20, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
    elseif v == 5 then
      -- Small White Rotating Circle + Bouncing ? (on Ground)
      DrawMarker(27, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.4001, 0.4001, 0.4001, 240, 240, 240, 35, 0, 0, 2, 1)
        elseif v == 6 then
          DrawMarker(32, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.2001, 0.4001, 0.8001, 240, 240, 240, 35, 1, 1, 2, 0)
        elseif v == 7 then
          -- White Rotating Chevron Bouncing.
      DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 240, 240, 240, 35, 1, 0, 2, 1)
    elseif v == 8 then
    -- Blue Static $.
        DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.7001, 0, 55, 240, 35, 0, 0, 2, 0)
    end
end

--- Produce A loop of markers to generate based on criteria.
---@param t table 'Contains coords as vector3, number for marker selection with c.marker functions, notification for dynamic entry with c.text functions and a func for callback function to do. {["coords"] = vector3(), ["number"] = 0,X, ["notification"] = {"KEYBOARD_USE", "DO X Y Z"}, ["callback"] = cb()}'
function c.marker.CreateThreadLoop(t)
    local tab = c.check.Table(t)
    -- Create the loop based on the Coordinates and marker style provided.
    Citizen.CreateThread(function()
        local tab = tab
        while true do
            local ped = PlayerPedId()
            local pos = vector3(GetEntityCoords(ped))
            local found = false
            local near = false
            local open = false
            Citizen.Wait(1)
            if c.data.GetLoadedStatus() then
                for i = 1, #tab, 1 do
                    local ords = tab[i].coords
                    local marker = tab[i].marker
                    local text = tab[i].notification
                    local cb = tab[i].callback
                    -- no point calculating distance twice in a loop, derp me.
                    local dist = Vdist(pos, ords)
                    if dist < 20 then
                        found = true
                        -- Draw marker
                        c.marker.SelectMarker(marker, ords)
                        if dist < 5 then
                            near = true
                            -- Show help
                            c.text.DisplayHelp(text[1], text[2])
                            if IsControlJustPressed(0, 38) then
                                open = true
                                -- Do action.
                                cb()
                            else
                                open = false
                            end
                        else
                            near = false
                        end
                    else
                        found = false
                    end
                end
            else
                Citizen.Wait(150 * #tab)
            end
        end
    end)
end
