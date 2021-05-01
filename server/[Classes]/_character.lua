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
    local data = c.sql.GetCharacterRow(character_id)
    local self = {}
    -- enable table searching.
    self.__index = self
    -- disable altering the direct line of data, must use set and get.
    self.__metatable = self
    ---- VARIABLES
    -- Strings
    self.Character_ID = data.Character_ID -- 50 Random Characters [Aa-Zz][0-9]
    self.City_ID = data.City_ID -- X-00000
    self.Birth_Date = data.Birth_Date
    self.First_Name = data.First_Name 
    self.Last_Name = data.Last_Name
    self.Full_Name = data.First_Name .. ' ' .. data.Last_Name
    self.Phone = data.Phone -- 200000 - 699999

    -- Booleans
    self.Wanted = data.Wanted

    -- Tables (JSONIZE)
    self.Appearance = json.decode(data.Appearance)
    self.Coords = json.decode(data.Coords)
    ---- FUNCTIONS
    --
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
            x = c.math.decimals(t.x, 2),
            y = c.math.decimals(t.y, 2),
            z = c.math.decimals(t.z, 2)
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
    return self
end
