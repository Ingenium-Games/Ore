-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
_c.data = {}
_c.pdex = {} -- player index = pdex (source numbers assigned by the server upon connection order)
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
-- ====================================================================================--
-- server level variables
_c.data.running = false
_c.data.loading = true
-- ====================================================================================--

function _c.data.Initilize()
    local num = 0
    local loaded = false
    local t = {
        [1] = 'DB: characters.Active = FALSE;',
        [2] = 'DB: ',
    }
    local function cb()
        num = num + 1
        _c.debug(t[num])
    end
    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etc..
        -- [1]
        _c.sql.DBResetActiveCharacters(cb)

        --
        loaded = true
    end)
    while not loaded do
        Wait(250)
    end
    _c.data.loading = false
    _c.debug('Loading Sequence Complete')
end

-- ====================================================================================--

function _c.data.AddPlayer(source)
    local src = tonumber(source)
    --
    table.insert(_c.pdex, src)
end

function _c.data.GetPlayer(source)
    local src = tonumber(source)
    --
    if _c.pdex[src] ~= nil then
        return _c.pdex[src]
    else
        return 0
    end
end

function _c.data.SetPlayer(source, data)
    local src = tonumber(source)
    --
    _c.pdex[src] = data
end

function _c.data.RemovePlayer(source)
    local src = tonumber(source)
    --
    if _c.pdex[src] ~= nil then
        table.remove(_c.pdex, src)
    end
end

-- ====================================================================================--
-- Merge the tables together. Tried doing multiple inheritance... cbf.

function _c.data.CreatePlayer(source, Character_ID)
    local src = source
    local lv1 = PlayerClass(src)
    local lv2 = CharacterClass(src, Character_ID)
    local obj = _c.table.merge(lv1,lv2)
    return obj
end

-- ====================================================================================--

-- Server to DB routine.
function _c.data.ServerSync()
    local function sync()
        local function cb()
            _c.debug('Synced with Database.')
        end
        _c.sql.SaveData(cb)
        SetTimeout(conf.serversync, sync)
    end
    SetTimeout(conf.serversync, sync)
end

-- ====================================================================================--

function _c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local data = _c.data.CreatePlayer(source, Character_ID)
    --
        _c.data.SetPlayer(src, data)
        Wait(250)
    --
    TriggerClientEvent('Client:Character:Loaded', src, data)
end

-- ====================================================================================--

RegisterNetEvent('Server:Packet.Update')
AddEventHandler('Server:Packet.Update', function(packet)
    local src = tonumber(source)
    local data = _c.data.GetPlayer(src)
    --
    data.SetCoords(packet.Coords)
end)

