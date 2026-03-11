## Entering the Discord webhook
Obviously we don't want to give out the webhook to your private server. You'll need to set the webhook in both payloads before converting them.
1. Open Discord
2. Select your server
3. Select and edit (settings wheel) your channel
4. Select Integrations
5. Select webhooks
6. Expand the desired webhook
7. Select Copy Webhook URL


## To kill the process once running in hidden mode
1. Open Powershall
2. run 'Get-Process powershell'
3. Identify the process (PID) created
4. run 'Stop-Process -Id (PID) -Force'
