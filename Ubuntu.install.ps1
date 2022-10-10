if ((Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux, VirtualMachinePlatform -All -NoRestart -LogLevel Warnings).RestartNeeded) {
  New-RegistryEntry -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce -Name Ubuntu
  return
}
& wsl.exe --set-default-version 2
& wsl.exe --update
& wsl.exe --shutdown

$ubuntuVersion = '22.04'
$ubuntuName = "Ubuntu-$ubuntuVersion"

$terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path -LiteralPath $terminalSettingsPath -PathType Leaf) {
  $terminalSettings = Get-Content -LiteralPath $terminalSettingsPath -Raw | ConvertFrom-Json
}
& winget.exe install --accept-package-agreements --accept-source-agreements --source msstore --exact --id 9PN20MSR04DW

if ($terminalSettings) {
  $terminalSettings.profiles.list = @($terminalSettings.profiles.list[0]) + @([PSCustomObject]@{ guid = '{f9ceaf27-504c-58d7-927c-d1d6a7ac7d3c}' }) + @($terminalSettings.profiles.list[1..($terminalSettings.profiles.list.Length)])
  ConvertTo-Json -InputObject $terminalSettings -Depth 100 | Set-Content -LiteralPath $terminalSettingsPath -Force -Verbose -ErrorAction Stop
}

$env:WSLENV = 'SystemRoot/pu:USERPROFILE/pu:LANG:LC_ADDRESS:LC_COLLATE:LC_CTYPE:LC_IDENTIFICATION:LC_MEASUREMENT:LC_MESSAGES:LC_MONETARY:LC_NAME:LC_NUMERIC:LC_PAPER:LC_TELEPHONE:LC_TIME:COLORTERM:VISUAL:EDITOR'
New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name WSLENV -Value $env:WSLENV -Verbose -ErrorAction Stop

$ubuntu = "ubuntu$($ubuntuVersion -replace '\.', '').exe"
& $ubuntu install --root --ui=none
& wsl.exe --shutdown
& wsl.exe --set-default $ubuntuName

& wsl.exe --cd $ToolboxRepository\Ubuntu --exec /bin/bash -c 'cp ./wsl.conf /etc'
& wsl.exe --terminate $ubuntuName

& wsl.exe --cd $ToolboxRepository\Ubuntu --exec /bin/bash -c '. install.root'

$defaultUser = $env:USERNAME
$defaultPassword = 'wsl'
$defaultGroups = @('adm', 'audio', 'cdrom', 'dialout', 'dip', 'floppy', 'netdev', 'plugdev', 'sudo', 'video')
& wsl.exe --exec /bin/bash -c "adduser --force-badname --uid 1001 --disabled-login --gecos '' '$defaultUser'; printf '%s:%s' '$defaultUser' '$defaultPassword' | chpasswd; usermod --append --groups '$($defaultGroups -join ',')' '$defaultUser'"
& wsl.exe --terminate $ubuntuName

& $ubuntu config --default-user $defaultUser
& wsl.exe --cd $ToolboxRepository\Ubuntu --exec /bin/bash -c '. install.user'

Write-Warning -Message "User ""$defaultUser"" has password ""$defaultPassword"". You should change it within Ubuntu with command: ""passwd"""
