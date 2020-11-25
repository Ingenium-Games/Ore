--====================================================================================--
--  MIT License 2020 : Twiitchter
--====================================================================================--

--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
--====================================================================================--

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
            local License_ID = _c.identifier(src)
            local function cb()
                TriggerClientEvent('Chat:Message', src, 'i18n Updated.')
            end
            _c.sql.DBSetUserLocale(arg[1], License_ID, cb)
        else
            TriggerClientEvent('Chat:Message', src, 'Error in locale selection.')
        end
        TriggerClientEvent('Chat:Message', src, 'Error in locale selection.')
    end
end, true)