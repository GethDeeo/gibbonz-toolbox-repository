$archive = (New-TemporaryFile).FullName
Start-BitsTransfer -Source ((Invoke-RestMethod -Uri https://api.github.com/repos/paintdotnet/release/releases/latest).assets | Where-Object -Property name -Like paint.net.*.install.x64.zip).browser_download_url -Destination $archive -Description Downloading... -DisplayName paint.net
$tempPath = Split-Path -LiteralPath $archive
Expand-Archive -LiteralPath $archive -DestinationPath $tempPath
Remove-Item -LiteralPath $archive
Invoke-Process -FilePath $tempPath\paint.net.*.install.x64.exe -ArgumentList /auto, DESKTOPSHORTCUT=0
Remove-Item -Path $tempPath\paint.net.*.install.x64.exe
