& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id Microsoft.OpenSSH.Beta --override '/passive /norestart ADDLOCAL=Client'

New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Type ExpandString -Value "$((Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').GetValue('Path', $null,'DoNotExpandEnvironmentNames').TrimEnd(';'));%ProgramFiles%\OpenSSH" -Verbose -ErrorAction Stop
$env:Path = "$([Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine));$([Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User))"

New-Item -ItemType Directory -Path $env:ProgramData\ssh -Force -Verbose -ErrorAction Stop > $null
Copy-Item -LiteralPath $ToolboxRepository\OpenSSH\ssh_config -Destination $env:ProgramData\ssh -Verbose -ErrorAction Stop
Set-Content -LiteralPath $env:ProgramData\ssh\ssh_known_hosts -Value $null -NoNewline -Verbose -ErrorAction Stop
