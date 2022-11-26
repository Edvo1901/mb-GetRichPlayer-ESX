fx_version 'cerulean'
game 'gta5'

server_scripts {
    'config.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

shared_script {
	'@es_extended/imports.lua',
    'config.lua',
}

lua54 'yes'