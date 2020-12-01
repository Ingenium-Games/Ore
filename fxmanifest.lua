------------------------------------------------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Twiitchter'
description "Ore: A multi-gamemode framwork."
version "0.4.5"
------------------------------------------------------------------------------
ui_page('nui/c.html')
------------------------------------------------------------------------------
-- shared
shared_scripts {'conf.lua', 'i18n/i18n.lua', 'i18n/*.lua', 'shared/c.lua'}
------------------------------------------------------------------------------
-- client
client_scripts {'client/_var.lua', 'shared/[Tools]/*.lua', 'client/**/*.lua', 'client/**/*.js'}
------------------------------------------------------------------------------
-- server
server_scripts {'@mysql-async/lib/MySQL.lua', 'server/_var.lua', 'shared/[Tools]/*.lua', 'server/**/*.lua', 'server/**/*.js'}
------------------------------------------------------------------------------
-- client exports
exports {'c'}
------------------------------------------------------------------------------
-- server exports
server_exports {'c'}
------------------------------------------------------------------------------
-- required resources
dependencies {'mysql-async', 'freecam', 'discordroles'}
------------------------------------------------------------------------------
-- files
files {'nui/c.js', 'nui/c.css', 'nui/c.html', 'nui/img/*.png', 'nui/jquery-3.5.1.min.js',
       'nui/jquery.mask.min.js', 'nui/jquery.validate.min.js'}
