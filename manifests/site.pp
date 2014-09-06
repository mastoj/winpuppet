module { 'joshcooper/powershell': ensure => 'present' }
module { 'rismoney/chocolatey': ensure => 'present' }

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
}

class eventstore {
	package { 'eventstore':
		ensure => installed,
		source => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}