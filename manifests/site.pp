node default {
	notify {"Stuff from default":}
}

node 'BEKK-TOMASJAN' {
	notify {"BEKK-TOMASJAN":}
	include eventstore
	include nirvanaservice
}

node 'winpuppet' {
	notify {"Notify from random":}
	notify {"I'm notifying you.":}
	include eventstore
	include nirvanaservice
}

if $::kernel == windows {
  # default package provider
  Package { provider => chocolatey }
}

class eventstore {
	package { 'eventstore':
		ensure => '3.0.0-rc9',
		source => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}

class nirvanaservice {
	package { 'nirvanaservice':
		ensure => '1.0.0',
		source => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}