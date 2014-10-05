$facts = @{"chocolateyinstall" = ($env:ChocolateyInstall).Replace("\", "/") }
$facts.Keys | % { Write-Host ([string]::Format("{0}={1}", $_, $facts[$_])) }