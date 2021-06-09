-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.markers = {}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
-- https://docs.fivem.net/docs/game-references/markers/

--- Select a premade marker style.
---@param v number "A number to select corresponding local array value."
---@param ords table "a vector3() or {x,y,z}"
function c.markers.SelectMarker(v, ords)
    local num = c.check.Number(v)
    local markers = {
        [0] = function()
            -- Blue Static Circle.
            DrawMarker(27, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.7001, 0, 55, 240, 35, 0, 0, 2, 0)
        end,
        [1] = function()
            -- Blue Static $.
            DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2,
                0)
        end,
        [2] = function()
            -- Blue Static ?.
            DrawMarker(32, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2,
                0)
        end,
        [3] = function()
            -- Blue Static Chevron.
            DrawMarker(20, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2,
                0)
        end,
        [4] = function() -- Mainly for pickups or notes or anything found on ground.
            -- Small White Rotating Circle + Bouncing ? (on Ground)
            DrawMarker(27, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.4001, 0.4001, 0.4001, 240, 240, 240,
                35, 0, 0, 2, 1)
            DrawMarker(32, ords[1], ords[2], ords[3] - 0.45, 0, 0, 0, 0, 0, 0, 0.2001, 0.4001, 0.8001, 240, 240, 240,
                35, 1, 1, 2, 0)
        end,
        [5] = function()
            -- White Rotating Chevron Bouncing.
            DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 240, 240, 240, 35, 1, 0,
                2, 1)
        end,
        [6] = function()
            -- Blue Static $.
            DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.7001, 0, 55, 240, 35, 0, 0, 2,
                0)
        end
    }
    if num then
        return markers[num]
    end
end

--- Produce A loop of markers to generate based on criteria.
---@param t table 'Contains coords as vector3, number for marker selection with c.marker functions, notification for dynamic entry with c.text functions and a func for callback function to do. {["coords"] = vector3(), ["number"] = 0,X, ["notification"] = {"KEYBOARD_USE", "DO X Y Z"}, ["callback"] = cb()}'
function c.markers.CreateThreadLoop(t)
    local tab = c.check.Table(t)
    local size = c.table.SizeOf(tab)
    -- Create the loop based on the Coordinates and marker style provided.
    Citizen.CreateThread(function()
        local tab = tab
        local size = size
        while true do
            local found = false
            local near = false
            local ped = PlayerPedId()
            local pos = vector3(GetEntityCoords(ped))
            Citizen.Wait(1)
            if c.data.GetLoadedStatus() then
                for i = 1, size, 1 do
                    local ords = tab[i].coords
                    local num = tab[i].number
                    local text = tab[i].notification
                    local cb = tab[i].callback
                    -- no point calculating distance twice in a loop, derp me.
                    local dist = Vdist(pos, ords)
                    if dist < 20 then
                        found = true
                        -- Draw marker
                        c.markers.SelectMarker(num, ords)
                        if dist < 5 then
                            near = true
                            -- Show help
                            c.text.DisplayHelp(text[1], text[2])
                            if IsControlJustPressed(0, 38) then
                                -- Do action.
                                cb()
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1250)
            end
        end
    end)
end
