& winget.exe install --accept-package-agreements --accept-source-agreements --source winget --exact --id OpenVPNTechnologies.OpenVPN --override '/passive /norestart ADDLOCAL=OpenVPN.GUI,OpenVPN.Service,OpenVPN,Drivers,Drivers.Wintun'

& "$env:ProgramFiles\OpenVPN\bin\tapctl.exe" delete 'OpenVPN Wintun'
