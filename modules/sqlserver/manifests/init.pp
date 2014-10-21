class sqlserver {
	package { 'sqlexpress2012':
		ensure => '1.0.0',
		source => 'c:\\files',
		install_options => ['-pre', '-debug'],
	}

	windowsfunctions::port { 'sqlserver':
		number    => 1433,
		enableTcp => true,
	}
}

