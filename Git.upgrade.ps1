& winget.exe upgrade --accept-package-agreements --accept-source-agreements --source winget --exact --id Git.Git

Remove-RegistryEntry -Path 'HKCU:\Console\Git Bash' -WarningAction SilentlyContinue
Remove-RegistryEntry -Path 'HKCU:\Console\Git CMD' -WarningAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Git\*" -Include 'Git FAQs (Frequently Asked Questions).url', 'Git Release Notes.lnk'

Update-Module -Scope AllUsers -Name posh-git
Uninstall-ModuleOldVersions -Name posh-git
