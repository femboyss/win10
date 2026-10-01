echo  "Dev: captainfahim7"
echo  "GitHub: github.com/captainfahim7"
echo  "Thanks for using https://github.com/femboyss/win10!"
# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://captainfahim7.github.io/WinRAR_Activator/WAS.cmd'

$FilePath = "$env:TEMP\WAS.cmd"

try {
    Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing -OutFile $FilePath
} catch {
    Write-Error $_
	Return
}

if (Test-Path $FilePath) {
    Start-Process $FilePath -Wait
    $item = Get-Item -LiteralPath $FilePath
    $item.Delete()

}
