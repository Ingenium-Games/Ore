-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
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
            DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
        end,
        [2] = function()
            -- Blue Static ?.
            DrawMarker(32, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
        end,
        [3] = function()
            -- Blue Static Chevron.
            DrawMarker(20, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 0, 55, 240, 35, 0, 0, 2, 0)
        end,
        [4] = function() -- Mainly for pickups or notes or anything found on ground.
            -- Small White Rotating Circle + Bouncing ? (on Ground)
            DrawMarker(27, ords[1], ords[2], ords[3]-0.45, 0, 0, 0, 0, 0, 0, 0.4001, 0.4001, 0.4001, 240, 240, 240, 35, 0, 0, 2, 1)
            DrawMarker(32, ords[1], ords[2], ords[3]-0.45, 0, 0, 0, 0, 0, 0, 0.2001, 0.4001, 0.8001, 240, 240, 240, 35, 1, 1, 2, 0)
        end,
        [5] = function()
            -- White Rotating Chevron Bouncing.
            DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 0.7001, 1.0001, 0.3001, 240, 240, 240, 35, 1, 0, 2, 1)
        end,
        [6] = function()
            -- Blue Static $.
            DrawMarker(29, ords[1], ords[2], ords[3], 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.7001, 0, 55, 240, 35, 0, 0, 2, 0)
        end,
    }
    if num then
        return markers[num]
    end
end

--- Produce A loop of markers to generate based on criteria.
---@param t table "Contains {["coords"] = vector3(), ["number"] = 0,X}"
---@param t2 table "Contains two values, first should be job, item or vehicle. Second is a Callback. ie {["vehicle"] = class, ["func"] = cb()}"
function c.markers.CreateThreadLoop(t, t2)
    local tab = c.check.Table(t)
    local size = c.table.SizeOf(tab)
    if not t2 then
        -- Create the loop based on the Coordinates and marker style provided.
        Citizen.CreateThread(function()
            local tab = tab
            local size = size
            while true do
                local found = false
                local close = true
                local ped = PlayerPedId()
                local pos = vector3(GetEntityCoords(ped))
                Citizen.Wait(1)    
                if c.data.GetLoadedStatus() then        
                    for i=1, size, 1 do
                        local ords = tab[i].coords
                        local num = tab[i].number
                        if (Vdist(pos, ords) < 20) then
                            found = true
                            -- Draw marker
                            c.markers.SelectMarker(num, ords)
                            if (Vdist(pos, ords) < 5) then
                                close = true
                                -- Help notifications??

                            end
                        end
                    end
                else
                    Citizen.Wait(1250)
                end
            end
        end)
    elseif t2["job"] then
        -- Create the loop based on the Coordinates and marker style provided.
        Citizen.CreateThread(function()
            local tab = tab
            local size = size
            while true do
                local found = false
                local close = true
                local ped = PlayerPedId()
                local pos = vector3(GetEntityCoords(ped))
                local job = c.data.GetPlayer().Job.Name
                Citizen.Wait(1)    
                if c.data.GetLoadedStatus() then
                    if job == t2["job"] then
                        for i=1, size, 1 do
                            local ords = tab[i].coords
                            local num = tab[i].number
                            if (Vdist(pos, ords) < 20) then
                                found = true
                                -- Draw marker
                                c.markers.SelectMarker(num, ords)
                                if (Vdist(pos, ords) < 5) then
                                    close = true
                                    -- Help notifications??
                                    if IsControlJustPressed(0, 54) then --E
                                        t2["func"]()
                                    end
                                end
                            end
                        end
                    end
                else
                    Citizen.Wait(1250)
                end
            end
        end)
    elseif t2["item"] then
        -- Create the loop based on the Coordinates and marker style provided.
        Citizen.CreateThread(function()
            local tab = tab
            local size = size
            while true do
                local found = false
                local close = true
                local ped = PlayerPedId()
                local pos = vector3(GetEntityCoords(ped))
                local item = exports["inventory"].HasItem(t2["item"])
                Citizen.Wait(1)    
                if c.data.GetLoadedStatus() then        
                    if item then
                        for i=1, size, 1 do
                            local ords = tab[i].coords
                            local num = tab[i].number
                            if (Vdist(pos, ords) < 20) then
                                found = true
                                -- Draw marker
                                c.markers.SelectMarker(num, ords)
                                if (Vdist(pos, ords) < 5) then
                                    close = true
                                    -- Help notifications??
                                    if IsControlJustPressed(0, 54) then --E
                                        t2["func"]()
                                    end
                                end
                            end
                        end
                    end
                else
                    Citizen.Wait(1250)
                end
            end
        end)
    elseif t2["vehicle"] then
        -- Create the loop based on the Coordinates and marker style provided.
        Citizen.CreateThread(function()
            local tab = tab
            local size = size
            while true do
                local found = false
                local close = true
                local ped = PlayerPedId()
                local pos = vector3(GetEntityCoords(ped))
                local vehclass = GetVehicleClass(GetVehiclePedIsIn(ped))
                Citizen.Wait(1)    
                if c.data.GetLoadedStatus() then        
                    if vehclass == t2["vehicle"] then
                        for i=1, size, 1 do
                            local ords = tab[i].coords
                            local num = tab[i].number
                            if (Vdist(pos, ords) < 35) then
                                found = true
                                -- Draw marker
                                c.markers.SelectMarker(num, ords)
                                if (Vdist(pos, ords) < 5) then
                                    close = true
                                    -- Help notifications??
                                    if IsControlJustPressed(0, 54) then --E
                                        t2["func"]()
                                    end
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
end