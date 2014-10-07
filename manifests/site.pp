
if $::kernel == windows {
  # default package provider
  Package { provider => chocolatey }
  Exec { provider => powershell }
}

node 'BEKK-TOMASJAN' {
	include nirvanaservice
	include eventstore
	include elasticsearch
}

node 'winpuppet1' {
	include nirvanaservice
	include eventstore
	include elasticsearch
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
