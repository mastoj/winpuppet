class eventstore {
	portmanager::port { 'eventstore':
		number    => 2113,
		enableTcp => true,
	}

	nirvanaservice::service {'eventstore': 
		config          => "puppet:///modules/eventstore/eventstore.json",
		ensure          => '3.0.0',
		pkgName         => 'eventstore',
		source          => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}
