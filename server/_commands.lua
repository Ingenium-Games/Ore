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

TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).", {})

RegisterCommand('switch', function(source)
    local src = tonumber(source)
    local Primary_ID = c.identifier(src)
    local Character_ID = c.sql.GetActiveCharacter(Primary_ID)
    -- Send the client/sever the events once the character has changed to inactive on the db. 
    c.sql.SetCharacterInActive(Character_ID, function()
        TriggerClientEvent('Client:Character:OpeningMenu', src)
        TriggerEvent('Server:Character:Request:List', src, Primary_ID)
    end)
end, false)

-- ====================================================================================--

TriggerEvent("chat:addSuggestion", "/noclip", "Admins Permission(s) Required.", {})

RegisterCommand('noclip', function(source)
	local src = tonumber(source)
	TriggerClientEvent('AceCommand:NoClip', src)
end, true)

-- ====================================================================================--

TriggerEvent("chat:addSuggestion", "/ban", "Admins Permission(s) Required.", {
    { name="TargetID", help="The Target's server ID in this session." }
})

RegisterCommand('ban', function(source, ...)
	local src = tonumber(source)
    local args = {...}
    if (type(args[1]) ~= 'number') then
        TriggerEvent('HudText', src, 'Invalid Number Used for /ban Command.')
	else
        if (args[1] == src) then
            TriggerEvent('HudText', src, 'You cannot /ban yourself.')
        else
            local Primary_ID = c.identifier(args[1])
            local xPlayer = c.data.GetPlayer(args[1])
            c.sql.SetBanned(Primary_ID, function()
                xPlayer.DropPlayer('You have been banned.')
                TriggerEvent('HudText', src, 'TargetID: '..args[1]..', has been banned.')
            end)
        end
    end
end, true)

-- ====================================================================================--

TriggerEvent("chat:addSuggestion", "/kick", "Admins Permission(s) Required.", {
    { name="TargetID", help="The Target's server ID in this session." }
})

RegisterCommand('kick', function(source, ...)
	local src = tonumber(source)
    local args = {...}
    if (type(args[1]) ~= 'number') then
        TriggerEvent('HudText', src, 'Invalid Number Used for /kick Command.')
	else
        if (args[1] == src) then
            TriggerEvent('HudText', src, 'You cannot /kick yourself.')
        else
            local xPlayer = c.data.GetPlayer(args[1])
            xPlayer.DropPlayer('You have been kicked.')
            TriggerEvent('HudText', src, 'TargetID: '..args[1]..', has been kicked.')
        end
    end
end, true)

-- ====================================================================================--

