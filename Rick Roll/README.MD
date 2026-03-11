## To kill the process once running in hidden mode
1. Open Powershall
2. run **Get-Process powershell**
3. Identify the process (PID) created
4. run **Stop-Process -Id (PID) -Force**
