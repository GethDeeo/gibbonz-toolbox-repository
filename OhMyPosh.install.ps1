$path = (Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').GetValue('Path', $null,'DoNotExpandEnvironmentNames').TrimEnd(';')

& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id JanDeDobbeleer.OhMyPosh --scope machine

Remove-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name POSH_THEMES_PATH
New-RegistryEntry -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Type ExpandString -Value $path

& "${env:ProgramFiles(x86)}\oh-my-posh\bin\oh-my-posh.exe" font install CascadiaCode
$terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path -LiteralPath $terminalSettingsPath -PathType Leaf) {
  $terminalSettings = Get-Content -LiteralPath $terminalSettingsPath -Raw | ConvertFrom-Json
  $terminalSettings.profiles.defaults.font.face = 'CaskaydiaCove NF'
  ConvertTo-Json -InputObject $terminalSettings -Depth 100 | Set-Content -LiteralPath $terminalSettingsPath -Force -Verbose -ErrorAction Stop
}

Copy-Item -LiteralPath $ToolboxRepository\OhMyPosh\default.omp.yaml -Destination ${env:ProgramFiles(x86)}\oh-my-posh\themes -Verbose -ErrorAction Stop
data add__profile_ps1 {
@'
if ($env:WT_SESSION) {
  & "${env:ProgramFiles(x86)}\oh-my-posh\bin\oh-my-posh.exe" init pwsh --config ((Test-Path -LiteralPath $HOME\.omp.yaml -PathType Leaf) ? "$HOME\.omp.yaml" : "${env:ProgramFiles(x86)}\oh-my-posh\themes\default.omp.yaml") | Invoke-Expression
  Write-Host
}

'@
}
Add-Content -LiteralPath $PROFILE.AllUsersAllHosts -Value $add__profile_ps1 -NoNewLine -Verbose -ErrorAction Stop
