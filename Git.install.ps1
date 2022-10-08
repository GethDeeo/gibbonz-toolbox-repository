& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id Git.Git --override "/SILENT ""/LOADINF=$ToolboxRepository\Git\Git.inf"""

$env:Path = "$([Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine));$([Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User))"

Install-Module -Scope AllUsers -Name posh-git > $null
Import-Module -Name posh-git
Add-Content -LiteralPath $PROFILE.AllUsersAllHosts -Value "Import-Module -Name posh-git`n" -NoNewLine -Verbose -ErrorAction Stop
