fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DRZ TEAM'
description 'DRZ_CELLSERVICE'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'shared/*.lua',
}

client_script {
    'client/*.lua'
}

server_script {
    'server/*.lua',
}

escrow_ignore {
    'server/*.lua',
    'client/*.lua',
    'shared/*.lua',
}

dependencies {
	'es_extended',
    'ox_lib'
}
