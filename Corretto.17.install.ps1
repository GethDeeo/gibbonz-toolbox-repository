$javaHome = (Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').GetValue('JAVA_HOME', $null,'DoNotExpandEnvironmentNames')
$path = (Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').GetValue('Path', $null,'DoNotExpandEnvironmentNames').TrimEnd(';')

& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id Amazon.Corretto.17
$javaHome17 = [Environment]::GetEnvironmentVariable('JAVA_HOME', [EnvironmentVariableTarget]::Machine)
New-Item -ItemType Junction -Path $env:ProgramFiles\jdk-17 -Target $javaHome17 > $null
New-NetFirewallRule -Group jdk -DisplayName jdk-17 -Program $javaHome17\bin\java.exe -Profile Domain, Private -Action Allow -Verbose -ErrorAction Stop > $null

New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name JAVA_HOME -Type ExpandString -Value %ProgramFiles%\jdk-17 -Verbose -ErrorAction Stop
$env:JAVA_HOME = [Environment]::GetEnvironmentVariable('JAVA_HOME', [EnvironmentVariableTarget]::Machine)
if ($javaHome) {
  New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Type ExpandString -Value $path
} else {
  New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Type ExpandString -Value "$path;%JAVA_HOME%\bin" -Verbose -ErrorAction Stop
}
$env:Path = "$([Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine));$([Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User))"

$javaToolOptions = [Environment]::GetEnvironmentVariable('JAVA_TOOL_OPTIONS', [EnvironmentVariableTarget]::Machine)
$javaFileEncoding = '-Dfile.encoding=UTF-8'
$javaToolOptions = $javaToolOptions -and $javaToolOptions -match '(?:^\s*|\S\s+)-Dfile\.encoding=(?<fileEncoding>\S*)(?:\s*$|\s+\S)' ? $javaToolOptions -replace "-Dfile\.encoding=$($Matches['fileEncoding'])", $javaFileEncoding : "$javaFileEncoding $javaToolOptions"
[Environment]::SetEnvironmentVariable('JAVA_TOOL_OPTIONS', $javaToolOptions.Trim(), [EnvironmentVariableTarget]::Machine)
$env:JAVA_TOOL_OPTIONS = [Environment]::GetEnvironmentVariable('JAVA_TOOL_OPTIONS', [EnvironmentVariableTarget]::Machine)
