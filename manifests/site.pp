
if $::kernel == windows {
  # default package provider
  Package { provider => chocolatey }
  Exec { provider => powershell }
}

# All is the same, so comma-separated. server1 is the vagrant hostname
node 'BEKK-TOMASJAN', 'winpuppet1', 'server1' {
	include portmanager
	include nirvanaservice
	include eventstore
	include elasticsearch
}
