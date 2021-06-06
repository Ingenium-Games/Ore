-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.affil = {}
--[[
NOTES.
    - This section is in relation to ped relationships based on roles or jobs.
    - Imagin a vargo rollin into baller territory. EzClapps and Vice Versa.
    - To really be used with PolyZones, to make sections of the city gang affiliated
    - for more and vast interactions. 
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

--[[
--str
local _, groupHash = AddRelationshipGroup(name)
--str
local retval = DoesRelationshipGroupExist(groupHash)
--hashx2
local num = GetRelationshipBetweenGroups(group1, group2)
--pedx2
local num = GetRelationshipBetweenPeds(ped1, ped2)
]]--

--[[
0 = Companion  
1 = Respect  
2 = Like  
3 = Neutral  
4 = Dislike  
5 = Hate  
255 = Pedestrians  
]]--

--[[
-- CALL TWICE, VICE VERSA ELSE - POOP
ClearRelationshipBetweenGroups(relationship, group1, group2)
SetPedRelationshipGroupDefaultHash(ped, hash)
SetRelationshipBetweenGroups(relationship, group1, group2)
SetPedRelationshipGroupHash(ped, hash)
]]--