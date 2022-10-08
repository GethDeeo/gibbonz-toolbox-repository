& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id Valve.Steam

Remove-Item -LiteralPath $env:PUBLIC\Desktop\Steam.lnk, "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam Support Center.url"
