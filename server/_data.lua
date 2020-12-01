-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.data = {}
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
    local num = 0
    local loaded = false
    local t = {
        [1] = 'DB: characters.Active = FALSE;',
        [2] = 'DB: ',
    }

    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etc..
        -- [1]
        c.sql.DBResetActiveCharacters(function()
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
        return 0
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
    end
end

-- ====================================================================================--
-- Merge the tables together. Tried doing multiple inheritance... cbf.

function c.data.CreatePlayer(source, Character_ID)
    local src = source
    local lv1 = PlayerClass(src)
    local lv2 = CharacterClass(src, Character_ID)
    local obj = c.table.merge(lv1,lv2)
    return obj
end

-- ====================================================================================--

-- Server to DB routine.
function c.data.ServerSync()
    local function sync()
        local function cb()
            c.debug('Synced with Database.')
        end
        c.sql.SaveData(cb)
        SetTimeout(conf.serversync, sync)
    end
    SetTimeout(conf.serversync, sync)
end

-- ====================================================================================--

function c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local data = c.data.CreatePlayer(source, Character_ID)
    c.sql.DBSetCharacterActive(Character_ID)
    --
        c.data.SetPlayer(src, data)
        Wait(250)
    --
    TriggerClientEvent('Client:Character:Loaded', src, data)
end

-- ====================================================================================--

RegisterNetEvent('Server:Packet.Update')
AddEventHandler('Server:Packet.Update', function(packet)
    local src = tonumber(source)
    local data = c.data.GetPlayer(src)
    --
    data.SetCoords(packet.Coords)
end)

