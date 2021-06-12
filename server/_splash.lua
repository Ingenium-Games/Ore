-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    local playerName = GetPlayerName(src)
    local id = c.identifier(src)
    local Last = c.sql.GetLastLogin(id)
    deferrals.handover({
        name = playerName,
        last = Last
    })
end)