-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

ui_page 'ui/index.html'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

dependency 'qb-core'
dependency 'qb-target'
