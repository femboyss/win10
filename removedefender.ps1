echo  "Dev: 1sam11"
echo  "Website: github.com/1sam11/"
echo  "Thanks for using https://github.com/femboyss/win10!"

#echo "This Script is currently broken!! Please try again later!!!#

Invoke-WebRequest -Uri "https://github.com/1sam11/remove-windows-defender/blob/master/remove_defender.bat" -OutFile "$env:TEMP\Defender.Remover.bat"
Start-Process "$env:TEMP\Defender.Remover.bat" -Verb RunAs
