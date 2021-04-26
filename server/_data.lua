-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.data = {} -- data table for funcitons.
c.pdex = {} -- player index = pdex (source numbers assigned by the server upon connection order)
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.seed)
-- ====================================================================================--
-- server level variables
c.data.running = false
c.data.loading = true
-- ====================================================================================--

function c.data.Initilize()
    local num, loaded = 0, false
    local t = {
        [1] = 'DB: characters.Active = FALSE;',
        [2] = 'DB: ',
    }

    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etc..
        -- [1]
        c.sql.ResetActiveCharacters(function()
            num = num + 1
            c.debug(t[num])
        end)
        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end

    c.data.loading = false
    c.debug('Loading Sequence Complete')
end

-- ====================================================================================--

function c.data.AddPlayer(source)
    local src = tonumber(source)
    --
    table.insert(c.pdex, src)
end

function c.data.GetPlayer(source)
    local src = tonumber(source)
    --
    if c.pdex[src] ~= nil then
        return c.pdex[src]
    else
        return false
    end
end

function c.data.SetPlayer(source, data)
    local src = tonumber(source)
    --
    c.pdex[src] = data
end

function c.data.RemovePlayer(source)
    local src = tonumber(source)
    --
    if c.pdex[src] ~= nil then
        table.remove(c.pdex, src)
    else
        c.pdex[src] = false
    end
end

function c.data.GetPlayers()
    return c.pdex
end


-- ====================================================================================--

-- Server to DB routine.
function c.data.ServerSync()
    local function Do()
        c.sql.SaveData(function()
            c.debug('Synced with Database.')
        end)
        SetTimeout(conf.serversync, Do)
    end
    SetTimeout(conf.serversync, Do)
end

-- Server to check for missing players / remove them.
function c.data.PlayersSync()
    local function Do()
        local players = GetPlayers()
        if type(players) == 'table' then
            for i=1, #players, 1 do
                local player = players[i]
                local PingCheck = GetPlayerPing(player)
                if PingCheck == 0 then
                    local data = GRPCore.GetPlayer(player)
                    c.sql.SaveUser(data, function()
                        c.sql.SetCharacterInActive(data.Character_ID, function()
                            c.data.RemovePlayer(player)
                            c.debug('Player Disconnection.')
                        end)
                    end)
                end
            end
        else
            c.debug('GetPLayers() is empty.')
        end
        SetTimeout(conf.playersync, Do)
    end
    SetTimeout(conf.playersync, Do)
end

-- ====================================================================================--

function c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local xPlayer = c.data.CreatePlayer(source, Character_ID)
    --
    c.sql.SetCharacterActive(Character_ID, function()
        c.data.SetPlayer(src, xPlayer)
        TriggerClientEvent('Client:Character:Loaded', src, xPlayer)
    end)
end

