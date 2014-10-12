# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
Write-Host "Provisioning machine"
if(Test-Path c:/downloads/puppet-3.6.2.msi) {
  Write-Host "Puppet already downloaded"
}
else {
  if(-Not (Test-Path c:/downloads)) {
    Write-Host "Creating download folder"
    md c:/downloads
  }
  Write-Host "Downloading puppet"
  Invoke-WebRequest https://downloads.puppetlabs.com/windows/puppet-3.6.2.msi -OutFile c:/downloads/puppet-3.6.2.msi  
}
Write-Host "Puppet downloaded, installing"
cd c:/downloads
try {
  Write-Host "Current folder:"
  pwd
  $exitCode = (Start-Process -FilePath "msiexec.exe" -ArgumentList "/qn /l*v puppet_install.txt /i puppet-3.6.2.msi" -Wait -Passthru).ExitCode
  & msiexec.exe /qn /l*v puppet_install.txt /i puppet-3.6.2.msi
  Write-Host "Install exit code: $exitCode"
  Write-Host "Puppet installed"
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
}
catch {
  Write-Host $_.Exception.Message
}
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
$env:Path = [System.Environment]::GetEnvironmentVariable("ChocolateyInstall","Machine")
SCRIPT


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|  
  config.vm.box = "kensykora/windows_2012_r2_standard"
  config.vm.communicator = "winrm"
  config.vm.network :forwarded_port, guest: 3389, host: 33389, id: "rdp", auto_correct: true
  config.vm.network :forwarded_port, guest: 9200, host: 9200, id: "elasticsearch", auto_correct: true
  config.vm.network :forwarded_port, guest: 2113, host: 2113, id: "eventstore", auto_correct: true
  config.vm.network :forwarded_port, guest: 7474, host: 7474, id: "neo4j", auto_correct: true

  config.vm.provision "shell", inline: $script

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"    
    puppet.module_path = "modules"
    #puppet.options = "--verbose --debug"
  end

  config.vm.define :server1 do |server1_config|
    server1_config.vm.hostname="server1"
  end
end
