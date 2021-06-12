-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local playerName = GetPlayerName(src)
    local id = c.identifier(src)
    local last = c.sql.GetLastLogin(id)
    deferrals.handover({
        name = playerName,
        last = last
    })
end)
