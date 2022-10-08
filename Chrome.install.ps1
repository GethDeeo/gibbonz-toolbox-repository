& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id Google.Chrome

Remove-Item -LiteralPath "$env:PUBLIC\Desktop\Google Chrome.lnk" 
