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

c.RegisterServerCallback('Request:CountActiveCharacters', function(source)
    local Count = c.sql.GetActiveCharactersAsCount()
    return Count
end)

c.RegisterServerCallback('Request:CountActiveCharactersByJob', function(source, jobname)
    local Jobname = tostring(jobname)
    local Count = c.sql.GetActiveCharactersByJobAsCount(Jobname)
    return Count
end)

