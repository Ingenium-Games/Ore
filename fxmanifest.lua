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
shared_scripts {'conf.lua', 'shared/*.lua', 'i18n/*.lua'}
------------------------------------------------------------------------------
-- client
client_scripts {'client/**/*.lua', 'client/**/*.js', 'nui/_client.lua'}
------------------------------------------------------------------------------
-- server
server_scripts {'@mysql-async/lib/MySQL.lua', 'server/_functions.lua', 'server/**/*.lua', 'server/**/*.js', 'nui/_server.lua'}
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
