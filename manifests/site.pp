
if $::kernel == windows {
  # default package provider
  Package { provider => chocolatey }
  Exec { provider => powershell }
}

node default {
	notify {"Stuff from default":}
#	require 'facter'
#	Facter.add(:ChocolateyInstall) do
#		setcode "echo $env:ChocolateyInstall"
#	end
#	productname
	$choco = $::ChocolateyInstall
	$productname = $::productname
	$msg = "Hello from |${choco}| |${productname}|"
	notify {"${msg}":}
	notify {$nsclient:}
}

node 'BEKK-TOMASJAN2' {
	include nirvanaservice
	include dotnet451
	nirvanaservice::service {'eventstore': 
		ensure          => '3.0.0',
		pkgName         => 'eventstore',
		source          => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}

node 'winpuppet1' {
	include nirvanaservice
	include dotnet451
	nirvanaservice::service {'eventstore': 
		ensure          => '3.0.0',
		pkgName         => 'eventstore',
		source          => 'https://www.myget.org/F/crazy-choco/',
		install_options => ['-pre'],
	}
}

class dotnet451 {
	class { 'dotnet': 
		version         => '4.5.1',
		deployment_root => 'C:/downloads/NDP451-KB2858728-x86-x64-AllOS-ENU.exe',
		require         => Download_file['dotnet451'],
	}

	download_file { 'dotnet451':
		site => "http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2",
		location => "C:/downloads",
		name => 'NDP451-KB2858728-x86-x64-AllOS-ENU.exe',
	}
}

define download_file(
        $site="",
        $location="",
        $creates="") {
    exec { $name:                                                                                                                     
        command => "Invoke-WebRequest ${site}/${name} -OutFile ${location}/${name}",                                                         
        creates => "${location}/${name}",
        timeout => 1800,
    }
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
