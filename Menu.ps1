do {
    Clear-Host
    Write-Host "=== Win10-11 Toolkit ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "ALL TOOLS ARE COMPATIBLE WITH WINDOWS 10 AND WINDOWS 11"
    Write-Host ""
    Write-Host "1. Remove Edge"
    Write-Host "2. Activate Windows"
    Write-Host "3. Optimize Windows 10 / 11"
    Write-Host "4. Install VLC"
    Write-Host "5. Install Discord"
    Write-Host "6. Install Steam"
    Write-Host "7. Install Notepad++"
    Write-Host "8. Install Revo Uninstaller"
    Write-Host "9. Install Microsoft Powertoys"
    Write-Host "10. Install WingetUI"
    Write-Host "11. Install SpotX (Spotify Cracked)"
    Write-Host "12. Remove Windows Defender"
    Write-Host "13. Install System Informer"
    Write-Host "14. WinRar Cracked (Needs WinRaR Installed)"
    Write-Host ""
    Write-Host "Q. Exit" -ForegroundColor Red
    Write-Host ""
    $choice = Read-Host "Choose"

    switch ($choice) {
        "1" { irm https://raw.githubusercontent.com/femboyss/win10/main/Remove-Edge.ps1 | iex }
        "2" { irm https://raw.githubusercontent.com/femboyss/win10/main/Activ-Win.ps1 | iex }
        "3" { irm https://raw.githubusercontent.com/femboyss/win10/main/Optimize-10.ps1 | iex }
        "4" { irm https://raw.githubusercontent.com/femboyss/win10/main/vlc.ps1 | iex }
        "5" { irm https://raw.githubusercontent.com/femboyss/win10/main/discord.ps1 | iex }
        "6" { irm https://raw.githubusercontent.com/femboyss/win10/main/steam.ps1 | iex }
        "7" { irm https://raw.githubusercontent.com/femboyss/win10/main/notepadplusplus.ps1 | iex }
        "8" { irm https://raw.githubusercontent.com/femboyss/win10/main/revouninstaller.ps1 | iex }
        "9" { irm https://raw.githubusercontent.com/femboyss/win10/main/powertoys.ps1 | iex }
        "10" { irm https://raw.githubusercontent.com/femboyss/win10/main/wingetui.ps1 | iex }
        "11" { $t="$env:TEMP\s.bat"; irm https://raw.githubusercontent.com/femboyss/win10/main/spotifycrack.bat -OutFile $t; start cmd "/c `"$t`"" }
        "12" { irm https://raw.githubusercontent.com/femboyss/win10/main/removedefender.ps1 | iex }
        "13" { irm https://raw.githubusercontent.com/femboyss/win10/main/sysinfo.ps1 | iex }
        "14" { irm https://raw.githubusercontent.com/femboyss/win10/main/winrar.ps1 | iex }
        "Q" { break }
        default { Write-Host "Invalid choice" -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }

    if ($choice -ne "Q") { Read-Host "Press Enter to return to menu" }

} while ($choice -ne "Q")

Write-Host ""
Write-Host "Dev: femboyss" -ForegroundColor Cyan
Write-Host "Website: https://github.com/femboyss" -ForegroundColor Cyan
Write-Host "Thanks for using https://github.com/femboyss/win10" -ForegroundColor Cyan
Write-Host ""
