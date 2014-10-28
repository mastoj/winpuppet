# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
Write-Host "Provisioning machine"
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
$env:Path = [System.Environment]::GetEnvironmentVariable("ChocolateyInstall","Machine")
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$arguments = @('install', 'puppet', '-Version', '3.7.1')
& "choco.exe" $arguments
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|  
  config.vm.guest = :windows 
  config.vm.box = ""
  config.vm.box_url = "file:///Users/thomas/Code/Sanbox/vagrant-win-2012/sio-vagrant-win2012-R2/win2012-R2.box"
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.communicator = "winrm"

  config.vm.provider :virtualbox do |v, override|
    v.memory = 4096
    v.name = "awesome_magic"
  end

  config.vm.network :forwarded_port, guest: 3389, host: 33389, id: "rdp", auto_correct: true


  config.vm.provision "shell", inline: $script

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"    
    puppet.module_path = "modules"
    puppet.options = "--verbose --debug"
  end

  config.vm.define :server1 do |server1_config|
    server1_config.vm.hostname="server1"
  end
end
