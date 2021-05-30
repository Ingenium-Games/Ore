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

function c.GetPlayer(source)
    return c.data.GetPlayer(source)
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

function c.GetPlayers()
    return c.data.GetPlayers()
end

function c.data.GetPlayers()
    return c.pdex
end

-- ====================================================================================--

-- Server to DB routine.
function c.data.ServerSync()
    local function Do()
        c.sql.SaveData(function()
            c.debug('[F] ServerSync() : Synced with Database.')
        end)
        SetTimeout(conf.serversync, Do)
    end
    SetTimeout(conf.serversync, Do)
end

-- ====================================================================================--

function c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    -- Fuck Metatable inheritance.
    local xUser = c.class.CreateUser(src)
    local xCharacter = c.class.CreateCharacter(Character_ID)
    local xPlayer = c.table.Merge(xUser, xCharacter)
    local data = {}
    -- what data needs to be sent to the client?
    data.ID = xPlayer.GetID()
    data.Character_ID = xPlayer.GetCharacter_ID()
    data.City_ID = xPlayer.GetCity_ID()
    data.Full_Name = xPlayer.GetFull_Name()
    data.Phone = xPlayer.GetPhone()
    data.Health = xPlayer.GetHealth()
    data.Armour = xPlayer.GetArmour()
    data.Hunger = xPlayer.GetHunger()
    data.Thirst = xPlayer.GetThirst()
    data.Stress = xPlayer.GetStress()
    data.Modifiers = xPlayer.GetModifiers()
    data.Apperance = xPlayer.GetApperance()

    --
    c.sql.SetCharacterActive(Character_ID, function()
        c.data.SetPlayer(src, xPlayer)
        --
        TriggerClientEvent('Client:Character:Loaded', src, data)
    end)
end
