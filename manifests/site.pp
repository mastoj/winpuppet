if $::kernel == windows {
  # default package provider
  Package { provider => chocolatey }
  Exec { provider => powershell }
}

# All is the same, so comma-separated. server1 is the vagrant hostname
node 'BEKK-TOMASJAN', 'winpuppet1', 'server1' {
	package { 'procexp':
		ensure          => '15.13',
	}

	include windowsfunctions
	include nirvanaservice
	include eventstore
	include javaserverjre
	include elasticsearch
	include neo4j

	windowsfunctions::scheduledtask { "testing" :
		action     => "echo \"\"hello\"\" >> c:\\log.txt",
		startDelay => 2,
	}
}
