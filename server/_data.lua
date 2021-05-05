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

math.randomseed(c.Seed)
-- ====================================================================================--

function c.data.Initilize()
    c.debug('Loading Sequence Begin.')
    local num, loaded = 0, false
    local t = {
        [1] = 'DB: Characters;',
        [2] = 'DB: Vehicles;',
        [3] = 'DB: Vehicles;',
        [4] = 'DB: Vehicles;',
        [5] = 'DB: Vehicles;',
        [6] = 'DB: Vehicles;'
    }
    --
    function cb()
        num = num + 1
        return t[num]
    end
    --
    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etc..
        -- [1]
        c.sql.ResetActiveCharacters(cb)
        -- [2]
        -- c.sql.
        -- [3]
        -- c.sql.
        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end

    c.Loading = false
    c.debug('Loading Sequence Complete.')
    c.Running = true
end

-- ====================================================================================--

function c.data.AddPlayer(source)
    table.insert(c.pdex, source)
end

function c.data.GetPlayer(source)
    return c.pdex[source]
end

function c.data.SetPlayer(source, data)
    c.pdex[source] = data
end

function c.data.RemovePlayer(source)
    c.pdex[source] = false
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
        local Players = GetPlayers()
        local xPlayers = c.data.GetPlayers()
        -- Is there a differance in size between the native and our Players Table?
        if c.table.SizeOf(Players) ~= c.table.SizeOf(xPlayers) then
            for i = 1, #xPlayers, 1 do
                local ply = xPlayers[i]
                local ping = GetPlayerPing(ply)
                if ping <= 1 then
                    local xPlayer = c.data.GetPlayer(ply)
                    c.sql.SaveUser(xPlayer, function()
                        c.sql.SetCharacterInActive(xPlayer.Character_ID, function()
                            c.debug('[F] PlayersSync() : Player Disconnection.')
                            c.data.RemovePlayer(player)
                        end)
                    end)
                end
            end
        end
        SetTimeout(conf.playersync, Do)
    end
    SetTimeout(conf.playersync, Do)
end

-- ====================================================================================--

function c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local xPlayer = c.class.CreateUser(source, Character_ID)
    xPlayer.Character = c.class.CreateCharacter(xPlayer.GetCharacter_ID())
    --
    c.sql.SetCharacterActive(Character_ID, function()
        c.data.SetPlayer(src, xPlayer)
        TriggerClientEvent('Client:Character:Loaded', src, xPlayer)
    end)
end
