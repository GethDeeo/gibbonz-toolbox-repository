& winget.exe upgrade --accept-package-agreements --accept-source-agreements --source winget --exact --id FarManager.FarManager

Remove-Item -LiteralPath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Far Manager 3 (x64)\Uninstall.lnk" -ErrorAction SilentlyContinue
