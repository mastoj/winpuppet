node default {
	notify {"Stuff from default":}
}

node 'BEKK-TOMASJAN' {
	nirvanaservice::service {'eventstore': 
		ensure          => '3.0.0-rc9',
		pkgName         => 'eventstore',
		source          => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}

node 'winpuppet1' {
	nirvanaservice::service {'eventstore': 
		ensure  => '3.0.0-rc9',
		pkgName => 'eventstore',
		source  => 'https://www.myget.org/F/crazy-choco/',
	}
}

if $::kernel == windows {
  # default package provider
  Package { provider => chocolatey }
  Exec { provider => powershell }
}

class nirvanaservice($version = '1.0.0') {
	package { 'nirvanaservice':
		ensure => $version,
		source => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}

define nirvanaservice::service($ensure, $source, $pkgName, $install_options) {
	if $ensure == 'absent' {
		exec {"uninstall_service_$name":
			command => "& nirvanaservice uninstall -servicename:$name",
			onlyif => [
				'powershell (Get-Service | Where-Object {$_.Name -eq "VSS"}).Length -eq 0'
			],
		}

		package { $pkgName:
			ensure => $version,
			source => $source,
			install_options => $install_options,
			require => Exec["uninstall_service_$name"],
		}
	}
	else {
		package { $pkgName:
			ensure => $version,
			source => $source,
			install_options => ['-pre'],
		}

		exec {"install_service_$name":
			command => "& nirvanaservice install -servicename:$name",
			require => Package[$name],
			onlyif => [
				'powershell (Get-Service | Where-Object {$_.Name -eq "VSS"}).Length -eq 0'
			],
		}

		service { $name:
			ensure => 'running',
			enable => true,
			require => Exec["install_service_$name"],
		}
	}
}
