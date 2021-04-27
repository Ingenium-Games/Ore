-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

-- STOP DROPPING THE GUNS GANG FUCKERS!
Citizen.CreateThread(function()
    while true do
	-- Every 2.5 Seconds.
	Citizen.Wait(2500)	
	-- Set Your Player as a Ped Entity to use its Coords in the L Function.
	local player = GetPlayerPed(-1)
	local loc = GetEntityCoords(player)
	-- Target Peds as the array and 25 being the distance around the player.
	-- This is not a normal L function.
	local data = c.GetPedsInArea(loc, 68)
		-- For each ped inside the Target array pulled from L.
		for _,v in pairs(data) do
			-- Are we sure its a ped?
			if not IsPedAPlayer(v) then
				-- If Entity is not dead then...
				if not IsPedDeadOrDying(v) then
					-- Dont Drop Guns!
					SetPedDropsWeaponsWhenDead(v, false)
					-- then if IsEntityAMissionEntity...
					if IsEntityAMissionEntity(v) then 
						break
					else
						RemovePedElegantly(v)
					end
				else
					-- Now if they are dead, I want to make sure we tell the server they are not needed. "CLEAN UP ISLE 7"
					if IsEntityDead(v) then
						if IsPedInAnyVehicle(v, false) then
							RemovePedElegantly(v)
						end
					end
				end
			end
		end	
    end
end)

