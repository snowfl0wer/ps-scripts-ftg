$folders = gci  -Directory
$foldersAmnt = ($folders | measure).Count
$scale = Read-Host -Prompt "Enter scale%"

for ($i=0; $i -lt $foldersAmnt; $i++){
    cd $folders[$i]
    if (Test-Path Telegram.exe) {
       .\Telegram.exe -scale $scale
    }
    cd ../
}
