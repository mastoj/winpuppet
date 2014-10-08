
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
