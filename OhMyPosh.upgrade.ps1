$path = (Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').GetValue('Path', $null,'DoNotExpandEnvironmentNames').TrimEnd(';')

& winget.exe upgrade --accept-package-agreements --accept-source-agreements --source winget --exact --id JanDeDobbeleer.OhMyPosh

Remove-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name POSH_THEMES_PATH -WarningAction SilentlyContinue
New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Type ExpandString -Value $path

Copy-Item -LiteralPath $ToolboxRepository\OhMyPosh\default.omp.yaml -Destination ${env:ProgramFiles(x86)}\oh-my-posh\themes -Verbose -ErrorAction Stop
