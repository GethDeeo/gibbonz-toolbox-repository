& winget.exe upgrade --accept-package-agreements --accept-source-agreements --source winget --exact --id clsid2.mpc-hc

Remove-Item -LiteralPath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\MPC-HC x64\Uninstall MPC-HC.lnk" -ErrorAction SilentlyContinue
