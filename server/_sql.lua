-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.sql = {} -- server
--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
-- SAVING VALUES TO THE DATABASE AS PER SYNC ROUTINES.
-- ====================================================================================--
-- @local id for async store & Store Query
local SaveData = -1
MySQL.Async.store(
    "UPDATE `characters` SET `Health` = @Health, `Armour` = @Armour, `Hunger` = @Hunger, `Thirst` = @Thirst, `Stress` = @Stress, `Coords` = @Coords, `Last_Login` = current_timestamp() WHERE `Character_ID` = @Character_ID;",
    function(id)
        SaveData = id
end)

--- Save Single User/Character
-- @source
-- @callback
function c.sql.SaveUser(data, cb)
    if data then
        -- Other Variables.
        local Health = data.GetHealth()
        local Armour = data.GetArmour()
        local Hunger = data.GetHunger()
        local Thirst = data.GetThirst()
        local Stress = data.GetStress()
        
        -- Tables require JSON Encoding.
        local Coords = json.encode(data.GetCoords())


        MySQL.Async.insert(SaveData, {

            -- Other Variables.
            ['@Health'] = Health,
            ['@Armour'] = Armour,
            ['@Hunger'] = Hunger,
            ['@Thirst'] = Thirst,
            ['@Stress'] = Stress,

            -- Table Informaiton.
            ['@Coords'] = Coords,

            ['@Character_ID'] = data.Character_ID,
        }, function(r)
            --do
        end)
        if cb then
            cb()
        end
    end
end

function c.sql.SaveData(cb)
    local xPlayers = c.data.GetPlayers()
    for i = 1, #xPlayers, 1 do
        if GetPlayerPing >= 1 then
            local data = c.data.GetPlayer(xPlayers[i])
            if data then
                -- Other Variables.
                local Health = data.GetHealth()
                local Armour = data.GetArmour()
                local Hunger = data.GetHunger()
                local Thirst = data.GetThirst()
                local Stress = data.GetStress()
        
                -- Tables require JSON Encoding.
                local Coords = json.encode(data.GetCoords())


                MySQL.Async.insert(SaveData, {

                    -- Other Variables.
                    ['@Health'] = Health,
                    ['@Armour'] = Armour,
                    ['@Hunger'] = Hunger,
                    ['@Thirst'] = Thirst,
                    ['@Stress'] = Stress,

                    -- Table Informaiton.
                    ['@Coords'] = Coords,

                    ['@Character_ID'] = data.Character_ID,
                }, function(r)
                    -- Do nothing.
                end)
            else
                -- The data is false, there fore the table of date is not there tobe saved.
            end
        else
            -- The player has 0 ping, they are offline and will be saved from the playerDropped Event OR by the PlayersSync() Function.
        end
    end
    -- These will all be completed prior to cb being run.
    -- upon the entire loop of saving/pasing data to the DB via a stored query, run the cb passed.
    if cb then
        cb()
    end
end

-- ====================================================================================--
-- CHARACTER CREATION QUERIES
-- ====================================================================================--

function c.sql.GenerateCharacterID(cb)
    local bool = false
    local new = nil
    repeat
        new = c.rng.chars(50)
        MySQL.Async.fetchScalar('SELECT `Primary_ID` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;', {
            ['@Character_ID'] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
        if cb then
            cb()
        end
        return new
end

function c.sql.GenerateCityID(cb)
    local bool = false
    local new = nil
    repeat
        local s1 = string.upper(c.rng.let())
        local s2 = c.rng.nums(5)
        new = string.format("%s-%s", s1, s2)
        MySQL.Async.fetchScalar('SELECT `Primary_ID` FROM `characters` WHERE `City_ID` = @City_ID LIMIT 1;', {
            ['@City_ID'] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
        if cb then
            cb()
        end
        return new
end

function c.sql.GeneratePhoneNumber(cb)
    local bool = false
    local new = nil
    repeat
        new = math.random(200000, 699999)
        MySQL.Async.fetchScalar('SELECT `Primary_ID` FROM `characters` WHERE `Phone` = @Phone LIMIT 1;', {
            ['@Phone'] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
        if cb then
            cb()
        end
        return new
end

-- ====================================================================================--
-- SHould remake htis one..
function c.sql.CreateCharacter(t, cb)
    MySQL.Async.execute(
    'INSERT INTO `characters` (`Primary_ID`, `Character_ID`, `City_ID`, `First_Name`, `Last_Name`, `Height`, `Birth_Date`, `Phone`, `Coords`) VALUES (@Primary_ID, @Character_ID, @City_ID, @First_Name, @Last_Name, @Height, @Birth_Date, @Phone, @Coords);',
    {
        Primary_ID = t.Primary_ID,
        Character_ID = t.Character_ID,
        City_ID = t.City_ID,
        First_Name = t.First_Name,
        Last_Name = t.Last_Name,
        Height = t.Height,
        Birth_Date = t.Birth_Date,
        Phone = t.Phone,
        Coords = t.Coords,
    }, function(data)
        if data then

        end
        if cb then
            cb()
        end
    end)
end

------------------------------------------------------------------------------
--- USERS TABLE QUERIES
------------------------------------------------------------------------------

--- Get - `Locale` from the users License_ID
-- @License_ID
function c.sql.GetLocale(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Locale` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return new
end

--- Set - Prefered locale or `Locale` for the users License_ID
-- @License_ID
function c.sql.SetLocale(locale, license_id, cb)
    local License_ID = license_id
    local Locale = locale
    MySQL.Async.execute('UPDATE `users` SET `Locale` = @Locale WHERE `License_ID` = @License_ID;', {
        ['@Locale'] = Locale,
        ['@License_ID'] = License_ID
    }, function(data)
        if data then
            --
        end
    end)
    if cb then
        cb()
    end
end


--- Get - `Ace` from the users License_ID identifier
-- @License_ID
function c.sql.GetAce(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Ace` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Set - `Ace` for the users License_ID
-- @License_ID
function c.sql.SetLocale(ace, license_id, cb)
    local License_ID = license_id
    local Ace = ace
    MySQL.Async.execute('UPDATE `users` SET `Ace` = @Ace WHERE `License_ID` = @License_ID;', {
        ['@Ace'] = Ace,
        ['@License_ID'] = License_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get - `Ban` from the users License_ID identifier
-- @License_ID
function c.sql.GetBanStatus(license_id, cb)
    local License_ID = license_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Ban` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Set - `Ban` = TRUE from the users License_ID identifier
-- @License_ID
function c.sql.SetBanned(license_id, cb)
    local License_ID = license_id
    MySQL.Async.execute('UPDATE `users` SET `Ban` = TRUE WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Set - `Ban` = FALSE from the users License_ID identifier
-- @License_ID
function c.sql.SetUnBanned(license_id, cb)
    local License_ID = license_id
    MySQL.Async.execute('UPDATE `users` SET `Ban` = FALSE WHERE `License_ID` = @License_ID LIMIT 1;', {
        ['@License_ID'] = License_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

------------------------------------------------------------------------------
--- CHARACTERS TABLE
------------------------------------------------------------------------------

--- Get - Info on the characters owned to prefill the multicharacter selection
-- @License_ID
function c.sql.GetCharacters(primary_id, cb)
    local Primary_ID = primary_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM `characters` WHERE `Primary_ID` = @Primary_ID LIMIT 100;', {
        ['@Primary_ID'] = Primary_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end


--- Get - # of characters owned = FALSE
-- @Primary_ID
function c.sql.GetCharacterCount(primary_id, cb)
    local Primary_ID = primary_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT COUNT(`Primary_ID`) AS "Count" FROM `characters` WHERE `Primary_ID` = @Primary_ID;',
        {
            ['@Primary_ID'] = Primary_ID
        }, function(data)
            result = data
            IsBusy = false
        end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    -- Always return a value.
    if result == nil then
        result = 0
    end
    --
    return result
end

function c.sql.DeleteCharacter(character_id, cb)
    local Character_ID = character_id
    MySQL.Async.execute('DELETE FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-- 

function c.sql.GetActiveCharactersByJobAsCount(jobname, cb
    local Job = tostring(jobname)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT COUNT(`Job`) AS "Count" FROM `characters` WHERE `Job` = @Job and `Active` = TRUE;',
        {['@Job'] = Job
        }, function(data)
            result = data
            IsBusy = false
        end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    -- Always return a value.
    if result == nil then
        result = 0
    end
    --
    return result
end

--- Get - All `Character_ID` that are currently marked as `Active` IS TRUE
function c.sql.GetActiveCharactersAsCount(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT COUNT(`Active`) AS "Count" FROM `characters` WHERE `Active` = TRUE;',
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    -- Always return a value.
    if result == nil then
        result = 0
    end
    --
    return result
end

--- Get - The entire ROW of data from Characters table where the Character_ID is the character id.
-- @Primary_ID
function c.sql.GetCharacter(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        result = data[1]
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - All `Character_ID` that are currently marked as `Active` IS TRUE
function c.sql.GetActiveCharacters(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT `Character_ID` FROM `characters` WHERE `Active` IS TRUE', {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `Active` = TRUE `Character_ID` from the Primary_ID identifier
-- @Primary_ID
function c.sql.GetActiveCharacter(primary_id, cb)
    local Primary_ID = primary_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar(
        'SELECT `Character_ID` FROM `characters` WHERE `Active` IS TRUE AND `Primary_ID` = @Primary_ID', {
            ['@Primary_ID'] = Primary_ID
        }, function(data)
            result = data
            IsBusy = false
        end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Active` = FALSE `Character_ID` from the Primary_ID identifier
-- @`Character_ID`
function c.sql.SetCharacterInActive(character_id, cb)
    local Character_ID = character_id
    MySQL.Async.execute('UPDATE `characters` SET `Active` = FALSE WHERE `Character_ID` = @Character_ID', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- SET - The `Active` = TRUE `Character_ID` from the Primary_ID identifier
-- @`Character_ID`
function c.sql.SetCharacterActive(character_id, cb)
    local Character_ID = character_id
    MySQL.Async.execute('UPDATE `characters` SET `Active` = TRUE WHERE `Character_ID` = @Character_ID', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-- Should the Server crash, this one is to reset all Active Characters Just incasethe Active Column is used to data identify users/characters in data pulls.
function c.sql.ResetActiveCharacters(cb)
    MySQL.Async.execute('UPDATE `characters` SET `Active` = FALSE;', {}, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get ALL - The `Wanted` Boolean TRUE from the characters table
function c.sql.GetWantedCharacters(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Character_ID` FROM `characters` WHERE `Wanted` IS TRUE;', {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Set - The `Wanted` Boolean TRUE from the `Character_ID`
-- @`Character_ID`
function c.sql.SetCharacterWanted(character_id, cb)
    local Character_ID = character_id
    MySQL.Async.execute('UPDATE `characters` SET `Wanted` IS TRUE WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Set - The `Wanted` Boolean FALSE from the `Character_ID`
-- @`Character_ID`
function c.sql.SetCharacterUnWanted(character_id, cb)
    local Character_ID = character_id
    MySQL.Async.execute('UPDATE `characters` SET `Wanted` IS FALSE WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get - The `City_ID` from the `Character_ID`
-- @`Character_ID`
function c.sql.GetCharacterFromPhone(phone, cb)
    local Phone = phone
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Character_ID` FROM `characters` WHERE `Phone` = @Phone LIMIT 1;', {
        ['@Phone'] = Phone
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `City_ID` from the `Character_ID`
-- @`Character_ID`
function c.sql.GetPhoneFromCharacter(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Phone` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `City_ID` from the `Character_ID`
-- @`Character_ID`
function c.sql.GetCityIdFromCharacter(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `City_ID` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `Character_ID` from the `City_ID`
-- @`City_ID`
function c.sql.GetCharacterFromCityId(city_id, cb)
    local City_ID = city_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Character_ID` FROM `characters` WHERE `City_ID` = @City_ID LIMIT 1;', {
        ['@City_ID'] = City_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `Coords` from the `Character_ID`
-- @`Character_ID`
function c.sql.GetCharacterCoords(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Coords` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = json.decode(data)
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Coords` from the `Character_ID`
-- @`Character_ID`
-- @Table of coords. {x=32.2,y=etc}
-- cb if any.
function c.sql.SetCharacterCoords(character_id, vector3, cb)
    local Character_ID = character_id
    local Coords = json.encode(vector3)
    MySQL.Async.execute('UPDATE `characters` SET `Coords` = @Coords WHERE `Character_ID` = @Character_ID;', {
        ['@Coords'] = Coords,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get - The `Appearance` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterAppearance(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Appearance` FROM `characters` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = json.decode(data)
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Appearance` from the `Character_ID`
-- @`Character_ID`
-- @style - TABLE VALUE
-- cb if any.
function c.sql.SetCharacterAppearance(character_id, style, cb)
    local Character_ID = character_id
    local Appearance = json.encode(style)
    MySQL.Async.execute('UPDATE `characters` SET `Appearance` = @Appearance WHERE `Character_ID` = @Character_ID;', {
        ['@Appearance'] = Appearance,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-----------------------
--- Character Statuses
-----------------------

--- Get - The `Health` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterHealth(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Health` FROM `characters` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Health` from the `Character_ID`
-- @`Character_ID`
-- @Health - Int VALUE
-- cb if any.
function c.sql.SetCharacterHealth(character_id, health, cb)
    local Health = health
    local Character_ID = character_id
    MySQL.Async.execute('UPDATE `characters` SET `Health` = @Health WHERE `Character_ID` = @Character_ID;', {
        ['@Health'] = Health,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get - The `Armour` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterArmour(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Armour` FROM `characters` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Armour` from the `Character_ID`
-- @`Character_ID`
-- @Armour - INT VALUE
-- cb if any.
function c.sql.SetCharacterArmour(character_id, armour, cb)
    local Character_ID = character_id
    local Armour = armour
    MySQL.Async.execute('UPDATE `characters` SET `Armour` = @Armour WHERE `Character_ID` = @Character_ID;', {
        ['@Armour'] = Armour,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get - The `Hunger` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterHunger(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Hunger` FROM `characters` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Hunger` from the `Character_ID`
-- @`Character_ID`
-- @Hunger - INT VALUE
-- cb if any.
function c.sql.SetCharacterHunger(character_id, hunger, cb)
    local Character_ID = character_id
    local Hunger = hunger
    MySQL.Async.execute('UPDATE `characters` SET `Hunger` = @Hunger WHERE `Character_ID` = @Character_ID;', {
        ['@Hunger'] = Hunger,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get - The `Thirst` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterThirst(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Thirst` FROM `characters` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Thirst` from the `Character_ID`
-- @`Character_ID`
-- @Thirst - INT VALUE
-- cb if any.
function c.sql.SetCharacterThirst(character_id, thirst, cb)
    local Character_ID = character_id
    local Thirst = thirst
    MySQL.Async.execute('UPDATE `characters` SET `Thirst` = @Thirst WHERE `Character_ID` = @Character_ID;', {
        ['@Thirst'] = Thirst,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get - The `Thirst` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterStress(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Stress` FROM `characters` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Stress` from the `Character_ID`
-- @`Character_ID`
-- @Stress - INT VALUE
-- cb if any.
function c.sql.SetCharacterStress(character_ID, stress, cb)
    local Character_ID = character_id
    local Stress = stress
    MySQL.Async.execute('UPDATE `characters` SET `Stress` = @Stress WHERE `Character_ID` = @Character_ID;', {
        ['@Stress'] = Stress,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end


-------------------------------------------------------------------------------
--- BANK TABLE
-------------------------------------------------------------------------------


--- Get - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterBank(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Bank` FROM `character_banks` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- @Bank - INT VALUE
-- cb if any.
function c.sql.SetCharacterBank(character_id, bank, cb)
    local Character_ID = character_id
    local Bank = bank
    MySQL.Async.execute('UPDATE `character_banks` SET `Bank` = @Bank WHERE `Character_ID` = @Character_ID;', {
        ['@Bank'] = Bank,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

function c.sql.TakeOutLoan(character_id, amount, duration, cb)
    local Character_ID = character_id
    local Bank = c.sql.GetCharacterBank(Character_ID)
    local Amount = amount
    local NewBank = Bank + Amount
    local Duration = duration
    --
    c.sql.SetCharacterBank(Character_ID, NewBank, function()
        c.sql.SetCharacterLoan(Character_ID, Amount, Duration)
    end)
end

--- Get - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.GetCharacterLoan(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT `Loan` FROM `character_banks` WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- @Bank - INT VALUE
-- cb if any.
function c.sql.SetCharacterLoan(character_id, loan, duration, cb)
    local Character_ID = character_id
    local Loan = loan
    local Duration = duration
    MySQL.Async.execute('UPDATE `character_banks` SET `Loan` = @Loan, `Duration` = @Duration, `Active` = TRUE WHERE `Character_ID` = @Character_ID;', {
        ['@Loan'] = Loan,
        ['@Duration'] = Duration,
        ['@Character_ID'] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-- cb if any.
function c.sql.TickOverLoanInterest(cb)
    MySQL.Async.execute('UPDATE `character_banks` SET `Loan` = Loan * 3.5 WHERE `Duration` >= 1;', {}, 
    function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-- cb if any.
function c.sql.TickOverLoanDuration(cb)
    MySQL.Async.execute('UPDATE `character_banks` SET `Duration` = Duration - 1 WHERE `Active` = TRUE;', {}, 
    function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-- cb if any.
function c.sql.TickOverLoansInactive(cb)
    MySQL.Async.execute('UPDATE `character_banks` SET `Active` = FALSE WHERE `Duration` = 0;', {}, 
    function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end





-------------------------------------------------------------------------------
--- VEHICLES TABLE
-------------------------------------------------------------------------------

function c.sql.GetVehiclesByCityId(City_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE `City_ID` = @City_ID LIMIT 100;', {
        ['@City_ID'] = City_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

function c.sql.GetVehiclesByPlate(Plate, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE `Plate` = @Plate LIMIT 1;', {
        ['@Plate'] = Plate
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end
