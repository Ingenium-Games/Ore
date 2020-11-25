-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(_c.seed)
-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
RegisterNetEvent('Server:Character:Request:List')
AddEventHandler('Server:Character:Request:List', function(source, Primary_ID)
	local src = tonumber(source)
    local Characters = _c.sql.DBGetUserCharacters(Primary_ID) 
	local Command = "OnJoin"
	-- Send the data table to the client that requested it...
	TriggerClientEvent('nui_open', src, Command, Characters)
end)
------------------------------------------------------------------------------
-- When they click the tick...
RegisterNetEvent('Server:Character:Request:Join')
AddEventHandler('Server:Character:Request:Join', function(Character_ID)
    local src = tonumber(source)
	-- If the User selected the NEW button on the NUI, the Character_ID will be listed as NEW, if this is the case, trigger the registration NUI?
    if (Character_ID == 'New') then
		local message = "OnNew"
        TriggerClientEvent('nui_open', src, message)
	elseif Character_ID ~= nil then
		local Coords = _c.sql.DBGetCharacterCoords(Character_ID)
		_c.sql.DBSetCharacterActive(Character_ID)
		_c.data.LoadPlayer(src, Character_ID)
        TriggerClientEvent('Client:Character:ReSpawn', src, Character_ID, Coords)
    end
end)

-- Currently not in use.
RegisterNetEvent('Server:Character:Request:Delete')
AddEventHandler('Server:Character:Request:Delete', function(Character_ID)
    local src = tonumber(source)
end)

RegisterNetEvent('Server:Character:Request:Create')
AddEventHandler('Server:Character:Request:Create', function(first_name, last_name, height, date)
    local src = tonumber(source)
    local char = _c.sql.GenerateCharacterID()
    local city = _c.sql.GenerateCityID()
    local phone = _c.sql.GeneratePhoneNumber()
    local prim = _c.identifier(src)
    local t = {Primary_ID = prim, First_Name = first_name, Last_Name = last_name, Height = height, Birth_Date = date, Character_ID = char, City_ID = city, Phone = phone, Coords = json.encode(conf.spawn)}
    local function cb()
        _c.data.LoadPlayer(src, char)
    end
    _c.sql.CreateCharacter(t, cb)
    Citizen.Wait(100)
    TriggerClientEvent('Client:Character:FirstSpawn', src)
    --
    TriggerClientEvent('creator:OpenCreator', src)
end)