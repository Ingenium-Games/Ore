-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
conf = {}
-- Just some time, because fuck maths.
conf.sec = 1000
conf.min = 60 * conf.sec
conf.hour = 60 * conf.min
conf.day = 24 * conf.hour
--[[
DEBUG :
    -- Up to you if you want to see whats going on or not, or open the DevTools. Scrub.
]]--
conf.debug = true
-- ====================================================================================--
--[[
GENERIC :
    [1] Map name.
    [2] Game Type.
]]--
conf.mapname = 'Los Santos'
conf.gametype = 'Role Play'
--[[
LOCALISATION/INTERNATIONALISATION also known as.. i18n :
    -- Standard language selection.
]]--
conf.locale = 'en'
--[[
ACE PERMISSIONS :
    -- The permissions are done inside the DB, so every time the User joins the ace gets set at the user level, the default level to assign to the DB on a new user joining is...
]]--
conf.ace = 'public' 
--[[
PRIMARY_ID :
    -- This will be what you choose to identify as the owner of the characters table within the DB.
    -- You can use any however I would leave it as the license as you need a legal copy of GTAV to
    -- play FiveM anyway, so everyone has a rockstar id, hence the license. But, up to you.
    -- 'fivem:' / 'steam:' / 'discord:' / 'license:' / 'ip:'
]]--
conf.identifier = 'license:'
--[[
UPDATE TIMES :
    [1] Client updates the server every...
    [2] Server updates the Database every...
    [3] Server to Check players table every...
]]--
conf.clientsync = 15 * conf.sec
conf.serversync = 2 * conf.min
conf.playersync = 5 * conf.min
--[[
SPAWN LOCATION : Airport.
]]--
conf.spawn = {
    x = -1050.30,
    y = -2740.95,
    z = 14.6
}
--[[
DEFERALS :
    [1] Force the user name of joining player to be alpha numeric characters only. No '<_-(.</?\)' etc.
    [2] Use Discord for your community?  https://forum.cfx.re/t/discordroles-a-proper-attempt-this-time/1579427 
    [3] Discord role to confirm the player is apart of the required guild.
]]--
conf.forcename = true
conf.discordperms = true
conf.discordrole = ''
--[[
SCREENSHOTS :
    -- Host URL
]]--
conf.imagehost = ''
conf.imagetoken = ''
--[[
INSTANCE/ROUTINGBUCKET :
    -- Default world for all players.
]]--
conf.instancedefault = 0
-- ====================================================================================--