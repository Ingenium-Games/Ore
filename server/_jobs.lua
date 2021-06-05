-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.jobs = {} -- DB Pull
c.job = {} -- Function Table
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

local CurrentlyActive = {}

function c.job.ActiveMembers()
    local tab = {}
    for k,v in ipairs(CurrentlyActive) do
        if not tab[v.name] then
            table.insert(tab, v.name)
            tab[v.name] = 0
        else
            tab[v.name] = tab[v.name] + 1
        end
    end
    return tab
end

-- req = source or number id calling event if internal
-- t = {name = 'police', grade = 1}, Job and then Grade
AddEventHandler('Server:Character:SetJob', function(req, t)
    local src = req or source
    CurrentlyActive[src] = t
end)

-- cleanup the table to reduce crap.
AddEventHandler('playerDropped', function()
    local src = req or source
    table.remove(CurrentlyActive, src)
end)

--[[
TriggerEvent('Server:Character:SetJob', self.ID, self.GetJob())
self.TriggerEvent('Client:Character:SetJob', self.GetJob())
]]--