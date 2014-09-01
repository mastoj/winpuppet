node default {
	notify {"Stuff from default":}
}

node 'BEKK-TOMASJAN' {
	notify {"BEKK-TOMASJAN":}
	include eventstore
}

node 'winpuppet' {
	notify {"Notify from random":}
	notify {"I'm notifying you.":}
	include eventstore
}

class eventstore {
	exec {'get_eventstore':
		command => 'Invoke-WebRequest http://download.geteventstore.com/binaries/EventStore-OSS-Win-v3.0.0-rc9.zip -OutFile c:\\downloads\\EventStore-OSS-Win-v3.0.0-rc9.zip',
		creates => "c:/downloads/EventStore-OSS-Win-v3.0.0-rc9.zip",
		provider => powershell,
	}

	file {'c:/downloads/EventStore-OSS-Win-v3.0.0-rc9.zip':
		mode => 0755,
		require => Exec["get_eventstore"],
	}	
}