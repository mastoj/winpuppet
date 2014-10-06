class eventstore {
	nirvanaservice::service {'eventstore': 
		config			=> "puppet:///modules/eventstore/eventstore.json",
		ensure          => '3.0.0',
		pkgName         => 'eventstore',
		source          => 'C:\\packages', #'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}