-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local playerName = GetPlayerName(src)
    local id = c.identifier(src)
    local ban = c.sql.GetBanStatus(id)
    local last = c.sql.GetLastLogin(id)
    Citizen.Wait(5)
    deferrals.handover({
        name = playerName,
        last = last,
    })
    Citizen.Wait(25)
    deferrals.update('Checking User')
    -- If you have/use discordperms..
    if not ban then
        if conf.discordperms then
            -- Force character names to not contain speical characters.
            if conf.forcename then
                Citizen.Wait(25)
                deferrals.update('Checking name matches approved characters.')
                if (playerName:match("%W")) then
                    Citizen.Wait(25)
                    deferrals.done('Your name must not contain special characters.')
                end
            end
            Citizen.Wait(25)
            deferrals.update('If your stuck on this, join our discord guild.')
            exports['discordroles']:isRolePresent(src, conf.discordrole, function(hasRole, roles)
                if hasRole then
                    Citizen.Wait(25)
                    deferrals.done()
                else
                    Citizen.Wait(25)
                    deferrals.done('Please visit our website to join our discord prior to joining...')
                end
            end)
        else
            if conf.forcename then
                Citizen.Wait(250)
                deferrals.update('Checking name matches approved characters.')
                if (playerName:match("%W")) then
                    Citizen.Wait(25)
                    deferrals.done('Please only use Alpha Numeric Characters in your name...')
                end
            else
                Citizen.Wait(25)
                deferrals.done()
            end
        end
    else
        Citizen.Wait(25)
        deferrals.done("Banned")
    end
end)
