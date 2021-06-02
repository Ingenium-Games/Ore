------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "ore: A FiveM C-ORE Resource to BUILD WITH"
version "0.5.5"
------------------------------------------------------------------------------
ui_page "nui/ore.html"
loadscreen "nui/splash.html"
------------------------------------------------------------------------------
-- shared
shared_scripts {"conf.lua", "conf.cars.lua", "conf.disable.lua", "shared/_c.lua"}
------------------------------------------------------------------------------
-- client
client_scripts {"client/_var.lua", "shared/[Tools]/*.lua"," client/_functions.lua", "client/**/*.lua", "client/**/*.js"}
------------------------------------------------------------------------------
-- server
server_scripts {"@mysql-async/lib/MySQL.lua", "server/_var.lua", "shared/[Tools]/*.lua", "server/_functions.lua", "server/**/*.lua", "server/**/*.js"}
------------------------------------------------------------------------------
-- client exports
exports {"c"}
------------------------------------------------------------------------------
-- server exports
server_exports {"c"}
------------------------------------------------------------------------------
-- required resources
dependencies {"mysql-async", "freecam", "discordroles"}
------------------------------------------------------------------------------
-- files
files { "nui/splash.js", "nui/splash.css", "nui/splash.html", "nui/ore.js", "nui/ore.css", "nui/ore.html", "nui/img/*.png", "nui/jquery-3.5.1.min.js",
       "nui/jquery.mask.min.js", "nui/jquery.validate.min.js"}
