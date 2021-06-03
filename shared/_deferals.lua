-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local playerName = GetPlayerName(src)
    local id = c.identifier(src)
    local lastplayed = c.sql.GetLastLogin(id)
    -- Splash/loading screen
    deferrals.handover({
        name = playerName,
        lastplay = lastplayed
    })
    Citizen.Wait(250)
    deferrals.update('Checking User Status.')
    Citizen.Wait(250)
    -- If you have/use discordperms..
    if Config.discordperms then
        -- Force character names to not contain speical characters.
        if Config.forcename then
            Citizen.Wait(250)
            deferrals.update('Checking name matches approved characters.')
            if (playerName:match("%W")) then
                deferrals.done('Please only use Alpha Numeric Characters in your name...')
            end
        end
        Citizen.Wait(250)
        deferrals.update('If your stuck on this, join our discord guild.')
        exports['discordroles']:isRolePresent(src, Config.discordrole, function(hasRole, roles)
            if hasRole then
                deferrals.done()
            else
                deferrals.done('Please visit our website to join our discord prior to joining...')
            end
        end)
    else
        if Config.forcename then
            Citizen.Wait(250)
            deferrals.update('Checking name matches approved characters.')
            if (playerName:match("%W")) then
                deferrals.done('Please only use Alpha Numeric Characters in your name...')
            end
        else
            deferrals.done()
        end
    end
end)
