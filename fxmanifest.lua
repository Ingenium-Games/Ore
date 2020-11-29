------------------------------------------------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Twiitchter'
description "A multi character _Core for FiveM"
version "0.4.2"
------------------------------------------------------------------------------
ui_page('nui/_c.html')
------------------------------------------------------------------------------
-- shared
shared_scripts {'conf.lua', 'i18n/i18n.lua', 'i18n/*.lua', 'shared/_c.lua'}
------------------------------------------------------------------------------
-- client
client_scripts {'client/_var.lua', 'shared/[Tools]/*.lua', 'client/**/*.lua', 'client/**/*.js'}
------------------------------------------------------------------------------
-- server
server_scripts {'@mysql-async/lib/MySQL.lua', 'server/_var.lua', 'shared/[Tools]/*.lua', 'server/**/*.lua', 'server/**/*.js'}
------------------------------------------------------------------------------
-- client exports
exports {'_c'}
------------------------------------------------------------------------------
-- server exports
server_exports {'_c'}
------------------------------------------------------------------------------
-- required resources
dependencies {'mysql-async', 'freecam', 'discordroles'}
------------------------------------------------------------------------------
-- files
files {'nui/_c.js', 'nui/_c.css', 'nui/_c.html', 'nui/img/*.png', 'nui/jquery-3.5.1.min.js',
       'nui/jquery.mask.min.js', 'nui/jquery.validate.min.js'}
