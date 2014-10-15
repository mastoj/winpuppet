class windowsfunctions {
	file { "c:/powershell_scripts":
		ensure             => directory,	
	}
	file { "c:/powershell_scripts/portmanager.ps1":
		source             => "puppet:///modules/windowsfunctions/portmanager.ps1",
		mode   	           => '0774',
		ensure             => file,
		source_permissions => ignore,
		require            => File['c:/powershell_scripts'],
	}
	file { "c:/powershell_scripts/scheduletask.ps1":
		source             => "puppet:///modules/windowsfunctions/scheduletask.ps1",
		mode   	           => '0774',
		ensure             => file,
		source_permissions => ignore,
		require            => File['c:/powershell_scripts'],
	}

	define port ($number, $enableTcp = true) {
		notify {"Port configuration $name": }
		notify {"Port number: $number, tcp: $enableTcp": }
		exec {"configure_port_$name":
			command   => "c:/powershell_scripts/portmanager.ps1 -name $name -port $number -enableTcp \$$enableTcp -enableUdp \$$enableUdp", 
			logoutput => true,
			require   => File['c:/powershell_scripts/portmanager.ps1']
		}
	}

	define scheduledtask ($action, $minutes = 10, $startDelay = 5) {
		exec { "$name":
			command => "c:/powershell_scripts/scheduletask.ps1 -name $name -action \"$action\" -minutes $minutes -startDelay $startDelay",
			logoutput => true,
			require   => File['c:/powershell_scripts/scheduletask.ps1'],
			onlyif    => "try { Get-ScheduledTask -TaskName $name; 1; } catch { exit 0;}",
		}
	}
}
