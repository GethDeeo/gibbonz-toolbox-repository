& wsl.exe --update
#& wsl.exe --shutdown

& wsl.exe --cd $ToolboxRepository\Ubuntu --user root --exec /bin/bash -c '. upgrade.root'
& wsl.exe --cd $ToolboxRepository\Ubuntu --exec /bin/bash -c '. upgrade.user'
