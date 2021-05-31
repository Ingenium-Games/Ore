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

function c.class.CreateCharacter(character_id)
    c.debug('Start Character Class Creation')
    local data = c.sql.GetCharacter(character_id)
    local self = {}
    -- Strings

    self.Character_ID = data.Character_ID -- 50 Random Characters [Aa-Zz][0-9]
    self.City_ID = data.City_ID -- X-00000

    self.Birth_Date = data.Birth_Date
    self.First_Name = data.First_Name
    self.Last_Name = data.Last_Name
    self.Full_Name = data.First_Name .. ' ' .. data.Last_Name

    self.Phone = data.Phone -- 200000 - 699999

    -- Integers
    self.Health = data.Health
    self.Armour = data.Armour
    self.Hunger = data.Hunger
    self.Thirst = data.Thirst
    self.Stress = data.Stress

    -- Booleans
    self.Wanted = data.Wanted

    -- Tables (JSONIZE)
    self.Appearance = json.decode(data.Appearance)
    self.Modifiers = json.decode(data.Modifiers)
    self.Coords = json.decode(data.Coords)
    ---- FUNCTIONS
    self.TriggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.ID, ...)
    end
    --
    self.GetIdentifier = function()
        return self.Character_ID
    end
    --
    self.GetCharacter_ID = function()
        return self.Character_ID
    end
    --
    self.GetCity_ID = function()
        return self.City_ID
    end
    --
    self.GetBirth_Date = function()
        return self.Birth_Date
    end
    --
    self.GetFirst_Name = function()
        return self.First_Name
    end
    --
    self.GetLast_Name = function()
        return self.Last_Name
    end
    --
    self.GetFull_Name = function()
        return self.Full_Name
    end
    --
    self.GetPhone = function()
        return self.Phone
    end
    --
    self.GetGender = function()
        if self.Appearance["sex"] ~= 0 then
            return 'Female'
        else
            return 'Male'
        end
    end
    -- 
    self.GetHealth = function()
        return self.Health
    end
    --
    self.SetHealth = function(v)
        self.Health = v
    end
    --
    self.GetArmour = function()
        return self.Armour
    end
    --
    self.SetArmour = function(v)
        self.Armour = v
    end
    --
    self.GetHunger = function()
        return self.Hunger
    end
    --
    self.SetHunger = function(v)
        self.Hunger = v
    end
    --
    self.GetThirst = function()
        return self.Thirst
    end
    --
    self.SetThirst = function(v)
        self.Thirst = v
    end
    --
    self.GetStress = function()
        return self.Stress
    end
    --
    self.SetStress = function(v)
        self.Stress = v
    end
    --
    self.GetModifiers = function()
        return self.Modifiers
    end
    --
    self.SetModifiers = function(t)
        self.Modifiers = t
    end
    --
    self.GetAppearance = function()
        return self.Appearance
    end
    --
    self.SetAppearance = function(v)
        self.Appearance = v
    end
    --
    self.GetCoords = function()
        return self.Coords
    end
    --
    self.SetCoords = function(t)
        self.Coords = {
            x = c.math.Decimals(t.x, 2),
            y = c.math.Decimals(t.y, 2),
            z = c.math.Decimals(t.z, 2)
        }
    end
    --
    self.GetWanted = function()
        return self.Wanted
    end
    --
    self.SetWanted = function(b)
        if type(b) == 'boolean' then
            self.Wanted = b
        end
    end
    --
    c.debug('End Character Class Creation')
    return self
end
