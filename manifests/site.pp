node default {
}

exec {'get_eventstore':
	command => "Invoke-WebRequest Invoke-WebRequest http://download.geteventstore.com/binaries/EventStore-OSS-Win-v3.0.0-rc9.zip -OutFile c:\\downloads\\EventStore-OSS-Win-v3.0.0-rc9.zip",
	creates => "c:/downloads/EventStore-OSS-Win-v3.0.0-rc9.zip",
}

file {'c:/downloads/EventStore-OSS-Win-v3.0.0-rc9.zip':
	mode => 0755,
	require => Exec["get_eventstore"],
}

notify {"I'm notifying you.":}