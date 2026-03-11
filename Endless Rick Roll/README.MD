## To kill the process once running in hidden mode
1. Open Powershall
2. run **Get-Process powershell**
3. Identify the process (PID) created
4. Replace (PID) in **Stop-Process -Id (PID) -Force**
5. Run your updated **Stop-Process -Id (PID) -Force** .e.g **Stop-Process -Id 27888 -Force**
