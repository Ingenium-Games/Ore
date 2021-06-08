-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.job = {} -- Function Table
c.jobs = {} -- DB Pull
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

local CurrentlyActive = {}

--- Return 
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

--- 
---@param job string
---@param grade string
function c.job.Exist(job, grade)
	grade = tostring(grade)
	if job and grade then
		if c.jobs[job] and c.jobs[job].grades[grade] then
			return true
		end
	end
	return false
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