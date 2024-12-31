fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Aamerikan'
description 'Pocket Crafting for QBX/OX Inventory'
version '1.0.3'

shared_script {
    '@ox_lib/init.lua', -- Ensure ox_lib is initialized
    'config.lua'        -- Load crafting configuration
}

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_lib',
    'ox_inventory'
}
