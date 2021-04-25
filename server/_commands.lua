--====================================================================================--
--  MIT License 2020 : Twiitchter
--====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.seed)
--====================================================================================--

RegisterCommand('switch', function(source)
    local src = tonumber(source)
    local Primary_ID = c.identifier(src)
    local char = c.sql.DBGetActiveCharacter(Primary_ID)
    c.sql.DBSetCharacterInActive(Character_ID)
    TriggerClientEvent('Client:Character:OpeningMenu', src)
    TriggerEvent('Server:Character:Request:List', src, Primary_ID)
end, true)

RegisterCommand('noclip', function(source)
	local src = tonumber(source)
	TriggerClientEvent('AceCommand:NoClip', src)
end, true)

