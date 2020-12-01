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

RegisterCommand('i18n', function(source, ...)
    local src = tonumber(source)
    local arg = ...
    if arg[1] ~= nil then
        local check = string.len(arg[1])
        if (check == 2) or (check == 3) then
            local License_ID = c.identifier(src)
            local function cb()
                TriggerClientEvent('Chat:Message', src, 'i18n Updated.')
            end
            c.sql.DBSetUserLocale(arg[1], License_ID, cb)
        else
            TriggerClientEvent('Chat:Message', src, 'Error in locale selection.')
        end
        TriggerClientEvent('Chat:Message', src, 'Error in locale selection.')
    end
end, true)