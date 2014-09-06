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

if $::kernel == windows {
  # default package provider
  Package { provider => chocolatey }
  Exec { provider => powershell }
}

class eventstore {
	include nirvanaservice
	package { 'eventstore':
		ensure => '3.0.0-rc9',
		source => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}

	exec {'install_eventstore_service':
		command => '& nirvanaservice install -servicename:eventstore',
		require => Package["eventstore"],
	}

	service { 'eventstore':
		ensure => 'running',
		enable => true,
	}
}

class nirvanaservice {
	package { 'nirvanaservice':
		ensure => '1.0.0',
		source => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}