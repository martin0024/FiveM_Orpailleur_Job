fx_version 'adamant'
game 'gta5'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    'src/components/*.lua',
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

    '@es_extended/locale.lua',
    'client/Farm.lua',
    'client/Actions.lua',
    'config.lua',


    'locales/fr.lua',
	'locales/en.lua'
}

server_scripts {
    'config.lua',
    'server/server.lua',
    '@es_extended/locale.lua',
    'locales/fr.lua',
	'locales/en.lua'
  }