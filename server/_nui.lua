-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
RegisterNetEvent('Server:Character:Request:List')
AddEventHandler('Server:Character:Request:List', function(source, Primary_ID)
    local src = tonumber(source)
    local Characters = c.sql.GetUserCharacters(Primary_ID)
    local Command = "OnJoin"
    -- Send the data table to the client that requested it...
    TriggerClientEvent('Client:Character:Open', src, Command, Characters)
    -- Place the user in their own instance until the user has joined and loaded.
    c.inst.SetPlayer(src, c.inst.New())
end)
------------------------------------------------------------------------------
-- When they click the tick...
RegisterNetEvent('Server:Character:Request:Join')
AddEventHandler('Server:Character:Request:Join', function(Character_ID)
    local src = tonumber(source)
    -- If the User selected the NEW button on the NUI, the Character_ID will be listed as NEW, if this is the case, trigger the registration NUI?
    if (Character_ID == 'New') then
        local message = "OnNew"
        TriggerClientEvent('Client:Character:Open', src, message)
    elseif Character_ID ~= nil then
        local Coords = c.sql.GetCharacterCoords(Character_ID)
        c.data.LoadPlayer(src, Character_ID)
        TriggerClientEvent('Client:Character:ReSpawn', src, Character_ID, Coords)
    elseif Character_ID == nil then
        local message = "OnNew"
        TriggerClientEvent('Client:Character:Open', src, message)
    end
end)

-- Currently not in use.
RegisterNetEvent('Server:Character:Request:Delete')
AddEventHandler('Server:Character:Request:Delete', function(Character_ID)
    local src = tonumber(source)
    local prim = c.identifier(src)
    c.sql.DeleteCharacter(Character_ID, function()
        TriggerEvent('Server:Character:Request:List', src, prim)
    end)
end)

RegisterNetEvent('Server:Character:Request:Create')
AddEventHandler('Server:Character:Request:Create', function(first_name, last_name, height, date)
    local src = tonumber(source)
    local char = c.sql.GenerateCharacterID()
    local city = c.sql.GenerateCityID()
    local phone = c.sql.GeneratePhoneNumber()
    local prim = c.identifier(src)
    local data = {
        Primary_ID = prim,
        First_Name = first_name,
        Last_Name = last_name,
        Height = height,
        Birth_Date = date,
        Character_ID = char,
        City_ID = city,
        Phone = phone,
        Coords = json.encode(conf.spawn)
    }
    c.sql.CreateCharacter(data, function()
        c.data.LoadPlayer(src, char)
        TriggerClientEvent('Client:Character:FirstSpawn', src)
        TriggerClientEvent('creator:OpenCreator', src)
    end)
end)
