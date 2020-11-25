-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Not all informaiton is required from the DB upon loading, online stored variables are required to be imported from the DB.
    - Identifiers can change like IP and Steam, etc; that is why they will either be Added to the DB, or Updated if they exist.
    - Referance and follow the 'PlayerConnecting:Server:Connecting' Event chain in the /core/client/client.lua.
    - Basically an xPlayer table. 
]] --

math.randomseed(_c.seed)
-- ====================================================================================--

function PlayerClass(source)
    local src = tonumber(source)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = _c.identifiers(src)
    local Ace = _c.sql.DBGetAce(License_ID)
    local Locale = _c.sql.DBGetLocale(License_ID)
    local self = {}
    --
    self.ID = src
    self.Steam_ID = Steam_ID
    self.FiveM_ID = FiveM_ID
    self.License_ID = License_ID
    self.Discord_ID = Discord_ID
    self.IP_Address = IP_Address
    self.Ace = Ace
    self.Locale = Locale
    --
    ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.FiveM_ID, self.Ace))
    ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.FiveM_ID, self.Ace))
    --
    self.kick = function(reason)
        DropPlayer(self.src, reason)
    end
    --
    self.GetAce = function()
        return self.Ace
    end
    --
    self.GetLocale = function()
        return self.Locale
    end
    --
    self.GetID = function()
        return self.ID
    end
    --
    self.GetSteam_ID = function()
        return self.Steam_ID
    end
    --
    self.GetFiveM_ID = function()
        return self.FiveM_ID
    end
    --
    self.GetLicense_ID = function()
        return self.License_ID
    end
    --
    self.GetDiscord_ID = function()
        return self.Discord_ID
    end
    --
    self.GetIP_Address = function()
        return self.IP_Address
    end
    --
    self.identifier = function()
        return self.GetLicense_ID()
    end
    --
    self.source = function()
        return self.GetID()
    end
    --
    return self
end
