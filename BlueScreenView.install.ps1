& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id NirSoft.BlueScreenView

Copy-Item -LiteralPath $ToolboxRepository\BlueScreenView\BlueScreenView.cfg -Destination ${env:ProgramFiles(x86)}\NirSoft\BlueScreenView -Verbose -ErrorAction Stop

Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\NirSoft BlueScreenView\*" -Include 'BlueScreenView Help.lnk', Uninstall.lnk
