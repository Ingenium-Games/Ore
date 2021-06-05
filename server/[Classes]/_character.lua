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
    self.Instance = data.Instance
    self.Health = data.Health
    self.Armour = data.Armour
    self.Hunger = data.Hunger
    self.Thirst = data.Thirst
    self.Stress = data.Stress

    -- Booleans
    self.Wanted = data.Wanted

    -- Tables (JSONIZE)
    self.Job = json.decode(data.Job)
    self.Accounts = json.decode(data.Accounts)
    
    self.Appearance = json.decode(data.Appearance)
    self.Modifiers = json.decode(data.Modifiers)
    self.Coords = json.decode(data.Coords)

    ---- FUNCTIONS
    self.TriggerEvent = function(event, ...)
		TriggerClientEvent(event, self.ID, ...)
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
    self.GetGender = function()
        if self.Appearance["sex"] ~= 0 then
            return 'Female'
        else
            return 'Male'
        end
    end
    --
    self.GetAccounts = function(b)
        local bool = c.check.Boolean(b)
        if bool then
            local Accounts = {}
            for k,v in ipairs(self.Accounts) do
                Accounts[v.name] = v.money
            end
            return Accounts
        else
            return self.Accounts
        end
    end
    --
    self.GetAccount = function(acc)
        for k, v in ipairs(self.Accounts) do
            if v.name == acc then
                return v
            end
        end
    end
    --
    self.GetMoney = function()
        local acc = self.GetAccount('money')
        if acc then
            return acc.money
        end
    end
    --
    self.SetMoney = function(v)
        local num = c.check.Number(v)
        if num >= 0 then
            local acc = self.GetAccount('money')
            if acc then
                local pMoney = acc.money
                local nMoney = c.math.Decimals(num, 0)
                acc.money = nMoney
            end
        end
    end
    --
    self.AddMoney = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('money')
            if acc then
                local nMoney = acc.money + c.math.Decimals(num, 0)
                acc.money = nMoney
            end
        end
    end
    --
    self.RemoveMoney = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('money')

            if acc then
                local nMoney = acc.money - c.math.Decimals(num, 0)
                acc.money = nMoney
            end
        end
    end
    --
    self.GetBank = function()
        local acc = self.GetAccount('bank')
        if acc then
            return acc.money
        end
    end
    --
    self.SetBank = function(v)
        local num = c.check.Number(v)
        if num >= 0 then
            local acc = self.GetAccount('bank')
            if acc then
                local pMoney = acc.money
                local nMoney = c.math.Decimals(num, 0)
                acc.money = nMoney
            end
        end
    end
    --
    self.AddBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('bank')
            if acc then
                local nMoney = acc.money + c.math.Decimals(num, 0)
                acc.money = nMoney
            end
        end
    end
    --
    self.RemoveBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('bank')
            if acc then
                local nMoney = acc.money - c.math.Decimals(num, 0)
                acc.money = nMoney
            end
        end
    end
    -- esx style, except table format.
    self.GetJob = function()
        return self.Job
    end
    --
    self.SetJob = function(t)
        local tab = c.check.Table(t)
        if c.job.Exist(t.job, t.grade) then
            local jobObject, gradeObject = c.jobs[t.job], c.jobs[t.job].grades[t.grade]
            --
            self.Job.Name = jobObject.name
            self.Job.Label = jobObject.label
            --
            self.Job.Grade = gradeObject.grade
            self.Job.Grade_Name = gradeObject.name
            self.Job.Grade_Label = gradeObject.label
            self.Job.Grade_Salary = gradeObject.salary
            --
            TriggerEvent('Server:Character:SetJob', self.ID, self.GetJob())
            self.TriggerEvent('Client:Character:SetJob', self.GetJob())
        else
            c.debug('Ignoring invalid .SetJob() usage for "%s"'):format(self.Name)
        end
    end
    --
    self.GetPhone = function()
        return self.Phone
    end
    --
    self.SetPhone = function(s)
        local str = c.check.String(s)
        self.Phone = str
    end
    -- 
    self.GetInstance = function()
        return self.Instance
    end
    --
    self.SetInstance = function(v)
        local num = c.check.Number(v)
        self.Instance = num
    end
    -- 
    self.GetHealth = function()
        return self.Health
    end
    --
    self.SetHealth = function(v)
        local _min = 0
        local _max = conf.defaulthealth
        local num = c.check.Number(v, _min, _max)
        self.Health = num
    end
    --
    self.GetArmour = function()
        return self.Armour
    end
    --
    self.SetArmour = function(v)
        local _min = 0
        local _max = conf.defaultarmour
        local num = c.check.Number(v, _min, _max)        
        self.Armour = num
    end
    --
    self.GetHunger = function()
        return self.Hunger
    end
    --
    self.SetHunger = function(v)
        local _min = 0
        local _max = 100
        local num = c.check.Number(v, _min, _max)
        self.Hunger = num
    end
    --
    self.GetThirst = function()
        return self.Thirst
    end
    --
    self.SetThirst = function(v)
        local _min = 0
        local _max = 100
        local num = c.check.Number(v, _min, _max)
        self.Thirst = num
    end
    --
    self.GetStress = function()
        return self.Stress
    end
    --
    self.SetStress = function(v)
        local _min = 0
        local _max = 100
        local num = c.check.Number(v, _min, _max)
        self.Stress = num
    end
    --
    self.GetModifiers = function()
        return self.Modifiers
    end
    --
    self.SetModifiers = function(t)
        local tab = c.check.Table(t)
        self.Modifiers = tab
    end
    --
    self.GetAppearance = function()
        return self.Appearance
    end
    --
    self.SetAppearance = function(t)
        local tab = c.check.Table(t)
        self.Appearance = tab
    end
    --
    self.GetCoords = function()
        return self.Coords
    end
    --
    self.SetCoords = function(t)
        local tab = c.check.Table(t)
        self.Coords = {
            x = c.math.Decimals(tab.x, 2),
            y = c.math.Decimals(tab.y, 2),
            z = c.math.Decimals(tab.z, 2)
        }
    end
    --
    self.GetWanted = function()
        return self.Wanted
    end
    --
    self.SetWanted = function(b)
        local b = c.check.Boolean(b)
        self.Wanted = b
    end
    --
    c.debug('End Character Class Creation')
    return self
end
