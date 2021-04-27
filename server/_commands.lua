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

TriggerEvent("chat:addSuggestion", "/noclip", "Admins Permissions Required.", {})

RegisterCommand('noclip', function(source)
	local src = tonumber(source)
	TriggerClientEvent('AceCommand:NoClip', src)
end, true)

-- ====================================================================================--

