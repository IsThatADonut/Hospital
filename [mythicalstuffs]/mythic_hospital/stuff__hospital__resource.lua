resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'EMS framework for Ascension: Miami-dade Country RP'

version '1.0'

client_scripts {
	'config.lua',
	'client/wound.lua',
	'client/main.lua',
	'client/items.lua',
}

server_scripts {
	'server/wound.lua',
	'server/main.lua',
	'server/items.lua',
}

dependencies {
	'mythic_progbar',
	'mythic_notify',
}

exports {
    'IsInjuredOrBleeding',
	'DoLimbAlert',
	'DoBleedAlert',
}

server_exports {
    'GetCharsInjuries',
}
