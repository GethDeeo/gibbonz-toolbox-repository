$javaHome = (Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').GetValue('JAVA_HOME', $null,'DoNotExpandEnvironmentNames')
$path = (Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').GetValue('Path', $null,'DoNotExpandEnvironmentNames').TrimEnd(';')

& winget.exe upgrade --accept-package-agreements --accept-source-agreements --source winget --exact --id Amazon.Corretto.17
if (!(Test-Path -LiteralPath $env:ProgramFiles\jdk-17\bin\java.exe -PathType Leaf)) {
  Remove-Item -LiteralPath (Get-Item $env:ProgramFiles\jdk-17).Target -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $env:ProgramFiles\jdk-17 -Force -ErrorAction SilentlyContinue
  $javaHome17 = [Environment]::GetEnvironmentVariable('JAVA_HOME', [EnvironmentVariableTarget]::Machine)
  New-Item -ItemType Junction -Path $env:ProgramFiles\jdk-17 -Target $javaHome17 > $null
  Get-NetFirewallRule -DisplayName jdk-17 | Get-NetFirewallApplicationFilter | Set-NetFirewallApplicationFilter -Program $javaHome17\bin\java.exe -Verbose
}

New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name JAVA_HOME -Type ExpandString -Value $javaHome
New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Type ExpandString -Value $path
