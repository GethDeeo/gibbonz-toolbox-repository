& winget.exe upgrade --accept-package-agreements --accept-source-agreements --source winget --exact --id OpenVPNTechnologies.OpenVPN

Remove-Item -LiteralPath $env:PUBLIC\Desktop\OpenVPN GUI.lnk, "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\OpenVPN\Shortcuts" -Recurse -ErrorAction SilentlyContinue
