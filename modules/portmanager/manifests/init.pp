class portmanager {
	file { "c:/powershell_scripts":
		ensure             => directory,	
	}
	file { "c:/powershell_scripts/portmanager.ps1":
		source             => "puppet:///modules/portmanager/portmanager.ps1",
		mode   	           => '0774',
		ensure             => file,
		source_permissions => ignore,
		require            => File['c:/powershell_scripts'],
	}

	define port ($number, $enableTcp = true) {
		notify {"Port configuration $name": }
		notify {"Port number: $number, tcp: $enableTcp": }
		exec {"configure_port_$name":
			command   => "c:/powershell_scripts/portmanager.ps1 -name $name -port $number -enableTcp \$$enableTcp -enableUdp \$$enableUdp", # template('portmanager/portmanager.ps1'),
			logoutput => true,
			require   => File['c:/powershell_scripts/portmanager.ps1']
		}
	}
}