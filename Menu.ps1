$BaseUrl = "https://raw.githubusercontent.com/femboyss/win10/main"

# Older Windows 10 builds may not use TLS 1.2 by default
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
} catch { }

function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Winget {
    return [bool](Get-Command winget -ErrorAction SilentlyContinue)
}

function Get-FileUrl {
    param([string]$File)
    # The random query string bypasses the raw.githubusercontent.com cache
    return ("{0}/{1}?nocache={2}" -f $BaseUrl, $File, [guid]::NewGuid().ToString("N"))
}

function New-MenuItem {
    param(
        [string]$Key,
        [string]$Label,
        [string]$File,
        [bool]$Admin = $false,
        [bool]$Confirm = $false
    )
    return [pscustomobject]@{
        Key     = $Key
        Label   = $Label
        File    = $File
        Admin   = $Admin
        Confirm = $Confirm
    }
}

$Items = @(
    (New-MenuItem -Key "0"  -Label "Install Winget (only if missing)"        -File "installwinget.ps1")
    (New-MenuItem -Key "1"  -Label "Remove Edge"                             -File "Remove-Edge.ps1"   -Admin $true -Confirm $true)
    (New-MenuItem -Key "2"  -Label "Activate Windows"                        -File "Activ-Win.ps1"     -Admin $true)
    (New-MenuItem -Key "3"  -Label "Optimize Windows 10 / 11"                -File "Optimize-10.ps1"   -Admin $true -Confirm $true)
    (New-MenuItem -Key "4"  -Label "Install VLC"                             -File "vlc.ps1")
    (New-MenuItem -Key "5"  -Label "Install Discord"                         -File "discord.ps1")
    (New-MenuItem -Key "6"  -Label "Install Steam"                           -File "steam.ps1")
    (New-MenuItem -Key "7"  -Label "Install Notepad++"                       -File "notepadplusplus.ps1")
    (New-MenuItem -Key "8"  -Label "Install Revo Uninstaller"                -File "revouninstaller.ps1")
    (New-MenuItem -Key "9"  -Label "Install Microsoft PowerToys"             -File "powertoys.ps1")
    (New-MenuItem -Key "10" -Label "Install WingetUI"                        -File "wingetui.ps1")
    (New-MenuItem -Key "11" -Label "Install SpotX (Spotify Cracked)"         -File "spotifycrack.bat")
    (New-MenuItem -Key "12" -Label "Remove Windows Defender"                 -File "removedefender.ps1" -Admin $true -Confirm $true)
    (New-MenuItem -Key "13" -Label "Install System Informer"                 -File "sysinfo.ps1")
    (New-MenuItem -Key "14" -Label "WinRAR Cracked (WinRAR must be installed)" -File "winrar.ps1"      -Admin $true)
    (New-MenuItem -Key "15" -Label "Install ExpressVPN"                      -File "expressvpn.ps1")
    (New-MenuItem -Key "16" -Label "Install NordVPN"                         -File "nordvpn.ps1")
    (New-MenuItem -Key "17" -Label "Install Mullvad VPN"                     -File "mullvadvpn.ps1")
    (New-MenuItem -Key "18" -Label "Install Malwarebytes"                    -File "malwarebytes.ps1")
    (New-MenuItem -Key "19" -Label "Install Malwarebytes AdwCleaner"         -File "malwarebytesadwcleaner.ps1")
)

function Show-Menu {
    Clear-Host
    Write-Host "=== Windows Toolkit ===" -ForegroundColor Cyan
    Write-Host ""

    if (Test-Admin) {
        Write-Host "Administrator: yes" -ForegroundColor Green
    } else {
        Write-Host "Administrator: no (some options need it)" -ForegroundColor Yellow
    }

    if (Test-Winget) {
        Write-Host "Winget: installed" -ForegroundColor Green
    } else {
        Write-Host "Winget: not found (use option 0)" -ForegroundColor Yellow
    }

    Write-Host ""
    foreach ($entry in $Items) {
        Write-Host ("{0,2}. {1}" -f $entry.Key, $entry.Label)
    }
    Write-Host ""
    Write-Host " Q. Exit" -ForegroundColor Red
    Write-Host ""
}

function Invoke-MenuItem {
    param($Item)

    if ($Item.Admin -and -not (Test-Admin)) {
        Write-Host "This option needs Administrator rights." -ForegroundColor Red
        Write-Host "Restart PowerShell as Administrator and try again." -ForegroundColor Red
        return
    }

    if ($Item.File -eq "installwinget.ps1" -and (Test-Winget)) {
        Write-Host "Winget is already installed. Nothing to do." -ForegroundColor Green
        return
    }

    if ($Item.Confirm) {
        $answer = "$(Read-Host ("'{0}' changes your system. Continue? (y/n)" -f $Item.Label))".Trim()
        if ($answer -notmatch '^(y|yes)$') {
            Write-Host "Cancelled." -ForegroundColor Yellow
            return
        }
    }

    $url = Get-FileUrl -File $Item.File
    $ext = [IO.Path]::GetExtension($Item.File).ToLower()
    $tmp = Join-Path $env:TEMP ("toolkit_{0}{1}" -f [guid]::NewGuid().ToString("N"), $ext)

    try {
        if ($ext -eq ".bat") {
            Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing -ErrorAction Stop
            $proc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$tmp`"" -Wait -NoNewWindow -PassThru
        } else {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
            # UTF-8 with BOM so Windows PowerShell 5.1 reads the file correctly
            Set-Content -Path $tmp -Value $response.Content -Encoding UTF8
            # Run in a child process so an "exit" or variable change in the script cannot break this menu
            $proc = Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tmp`"" -Wait -NoNewWindow -PassThru
        }

        if ($proc -and $proc.ExitCode -ne 0) {
            Write-Host ("The script finished with exit code {0}." -f $proc.ExitCode) -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host ("Error: {0}" -f $_.Exception.Message) -ForegroundColor Red
    }
    finally {
        Remove-Item -Path $tmp -Force -ErrorAction SilentlyContinue
    }
}

$running = $true
while ($running) {
    Show-Menu
    $choice = "$(Read-Host 'Choose')".Trim()

    if ($choice -ieq "q") {
        $running = $false
        continue
    }

    $selected = $Items | Where-Object { $_.Key -eq $choice }

    if ($selected) {
        Invoke-MenuItem -Item $selected
        Read-Host "Press Enter to return to menu" | Out-Null
    } else {
        Write-Host "Invalid choice" -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}

Write-Host ""
Write-Host "Dev: femboyss" -ForegroundColor Cyan
Write-Host "Website: https://github.com/femboyss" -ForegroundColor Cyan
Write-Host "Thanks for using https://github.com/femboyss/win10" -ForegroundColor Cyan
Write-Host ""
