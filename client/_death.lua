-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[ 
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

local classes = {
[0] = "Compact",
[1] = "Sedan",
[2] = "SUV",
[3] = "Coupe", 
[4] = "Muscle",
[5] = "Sports Classic", 
[6] = "Sport",
[7] = "Super",
[8] = "Motorcycles",  
[9] = "Off-road",
[10] = "Industrial", 
[11] = "Utility",  
[12] = "Van",
[13] = "Cycle",
[14] = "Boat",
[15] = "Helicopter",  
[16] = "Plane",
[17] = "Service",
[18] = "Emergency",
[19] = "Military",
[20] = "Commercial",
[21] = "Train",
}

local function PlayerKilled()
    local ply = PlayerId()
    local ped = PlayerPedId()
    local pvp = false
    local cause = GetPedCauseOfDeath(ped)
    local source = GetPedSourceOfDeath(ped)

    if source ~= 0 then
        local type = GetEntityType(source)
        if type == 1 then
            local attacker, weapon = NetworkGetEntityKillerOfPlayer(ply)
            local isplayer = IsPedAPlayer(attacker)
            if isplayer then
                pvp = {['source'] = NetworkGetPlayerIndexFromPed(attacker), ['weapon'] = weapon}
            end 
        elseif type == 2 then
            local attacker = GetPedInVehicleSeat(source, 1)
            local class = GetVehicleClass(source)
            local colours = GetVehicleColours(source)
            local isplayer = IsPedAPlayer(attacker)
            if isplayer then
                pvp = {['source'] = NetworkGetPlayerIndexFromPed(attacker), ['class'] = classes[class], }
            end 
        
        end
    end
    
    local data = {
        PVP = pvp,
        Coords = vector3(GetEntityCoords(ped)),
    }
    TriggerEvent('Client:Character:Death', data)
    TriggerServerEvent('Server:Character:Death', data)
end

Citizen.CreateThread(function()
    local IsDead = false
    while true do
        Citizen.Wait(1)
        if c.data.GetLoadedStatus() then
            local ply = PlayerId()
            local ped = PlayerPedId()
            while IsDead and IsPlayerDead() do
                Citizen.Wait(250)
            end
            if (IsPedFatallyInjured(ped) and not IsDead) or IsPlayerDead() then
                IsDead = true
                PlayerKilled()
            elseif not IsPedFatallyInjured(ped) and IsPlayerPlaying(ply) then
                IsDead = false
                Citizen.Wait(50)
            end
        else
            Citizen.Wait(1250)
        end
    end
end)