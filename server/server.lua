-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
SetGameType(conf.gametype)
SetMapName(conf.mapname)
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
-- ====================================================================================--
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    --
    OnStart()
    --
end)
-- ====================================================================================--
function OnStart()
    _c.data.Initilize()
    while _c.data.loading do
        Wait(250)
    end
    _c.data.ServerSync()
end
-- ====================================================================================--
RegisterNetEvent('PlayerConnecting:Server:Connecting')
AddEventHandler('PlayerConnecting:Server:Connecting', function()
    local src = tonumber(source)
    local Primary_ID = _c.identifier(src)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = _c.identifiers(src)
    --
    if _c.pdex[src] == nil then
        _c.data.AddPlayer(src)
        if License_ID then
            MySQL.Async.fetchScalar('SELECT `License_ID` FROM users WHERE `License_ID` = @License_ID LIMIT 1;', {
                ['@License_ID'] = License_ID
            }, function(r)
                if (r ~= nil) then
                    -- Update their steam, discord if they do not exist in the db and their ip address upon every login.
                    MySQL.Async.execute(
                        'UPDATE users SET `Steam_ID` = IFNULL(`Steam_ID`,@Steam_ID), `FiveM_ID` = IFNULL(`FiveM_ID`,@FiveM_ID), `Discord_ID` = IFNULL(`Discord_ID`,@Discord_ID), `IP_Address` = @IP_Address, `Last_Login` = current_timestamp() WHERE `License_ID` = @License_ID;',
                        {
                            License_ID = License_ID,
                            FiveM_ID = FiveM_ID,
                            Steam_ID = Steam_ID,
                            Discord_ID = Discord_ID,
                            IP_Address = IP_Address
                        }, function(r)
                            -- User Found and Updated, Now ...
                            TriggerEvent('Server:Request:Time', src)
                            TriggerClientEvent('Client:Character:OpeningMenu', src)
                            TriggerEvent('Server:Character:Request:List', src, Primary_ID)
                        end)
                else
                    MySQL.Async.execute(
                        'INSERT INTO users (`Steam_ID`, `License_ID`, `FiveM_ID`, `Discord_ID`, `Ace`, `Locale`, `Ban`, `IP_Address`) VALUES (@Steam_ID, @License_ID, @FiveM_ID, @Discord_ID, @Ace, @Locale, @Ban, @IP_Address);',
                        {
                            Steam_ID = Steam_ID,
                            License_ID = License_ID,
                            FiveM_ID = FiveM_ID,
                            Discord_ID = Discord_ID,
                            Ace = conf.ace,
                            Locale = conf.locale,
                            Ban = 0,
                            IP_Address = IP_Address
                        }, function(r)
                            -- New User Created, Now ...
                            TriggerEvent('Server:Request:Time', src)
                            TriggerClientEvent('Client:Character:OpeningMenu', src)
                            TriggerEvent('Server:Character:Request:List', src, Primary_ID)
                        end)
                end
            end)
        else
            DropPlayer(src, 'Contact the Server Owner, with the info of "License_ID not found".')
        end
    end
end)

-- ====================================================================================--

AddEventHandler('playerDropped', function()
    local src = tonumber(source)
    local data = _c.data.GetPlayer(src)
    --
    if type(data) == 'table' then
        local function cb()
            _c.data.RemovePlayer(src)
            _c.debug('^7[^2Saved^7] Player Disconnection.')
        end
        _c.sql.SaveUser(data, cb)
        _c.sql.DBSetCharacterInActive(data.Character_ID)
    else
        _c.data.RemovePlayer(src)
    end
end)