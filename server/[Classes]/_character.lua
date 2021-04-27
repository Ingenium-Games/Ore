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

function CharacterClass(source, Character_ID)
    local src = tonumber(source)
    local data = c.sql.GetCharacterRow(Character_ID)
    local self = {}
    --
    self.Character_ID = data.Character_ID
    self.City_ID = data.City_ID
    self.Bank = data.Bank
    self.Birth_Date = data.Birth_Date
    self.Name = data.First_Name .. ' ' .. data.Last_Name
    self.Phone = data.Phone
    self.Appearance = json.decode(data.Appearance)
    self.Inventory = json.decode(data.Inventory)
    self.Coords = json.decode(data.Coords)
    self.Job = json.decode(data.Job)
    self.Status = json.decode(data.Status)
    self.Wanted = data.Wanted
    --
    self.GetGender = function()
        return self.skin["sex"]
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
    self.GetInventory = function()
        return self.Inventory
    end
    --
    self.SetInventory = function(k, v)
        self.Inventory[k] = v
    end
    --
    self.AddInventory = function(k, v)
        table.insert(self.Inventory, k)
        self.Inventory[k] = v
    end
    --
    self.RemoveInventory = function(k)
        table.remove(self.Inventory, k)
    end
    --
    self.GetBank = function()
        return c.math.decimals(self.Bank, 2)
    end
    --
    self.SetBank = function(num)
        self.Bank = c.math.decimals(num, 2)
    end
    --	
    self.AddBank = function(num)
        local bank = self.GetBank()
        bank = bank + num
        self.SetBank(bank)
    end
    --
    self.RemoveBank = function(num)
        local bank = self.GetBank()
        bank = bank - num
        self.SetBank(bank)
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
    self.SetWanted = function(bool)
        if type(bool) == 'boolean' then
            self.Wanted = bool
        end
    end
    --
    return self
end
