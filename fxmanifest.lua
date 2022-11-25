fx_version 'cerulean'
game 'gta5'

server_scripts {
    'config.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

shared_script {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
    'config.lua',
}

lua54 'yes'

escrow_ignore {
	'config.lua',
    'server/*.lua',
	'locales/*.lua',
}
dependency '/assetpacks'