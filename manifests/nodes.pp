node default {
	notify { 'YOLO': }
}

node 'winpuppet1', 'server1' {
	include windowsfunctions
	include nirvanaservice
	include eventstore
	include javaserverjre
	include elasticsearch
#	include sqlserver
	include neo4j

	elasticsearch::plugin { 'marvel': }
}

package { 'procexp':
	ensure => '15.13',
}


#	file { 'c:/testing.ps1':
#		content	=> "\"YOLO\" | Out-File c:\\log2.txt -Append"
#	}
#
#	windowsfunctions::scheduledtask { "testing" :
#		action     => "cmd.exe",
#		arguments => "/C echo \"\"hello\"\" >> c:\\log.txt",
#		startDelay => 2,
#	}
#
#	windowsfunctions::scheduledtask { "testing2" :
#		action     => "powershell",
#		arguments => "-c \"\"c:/testing.ps1\"\"",
#		startDelay => 2,
#	}
