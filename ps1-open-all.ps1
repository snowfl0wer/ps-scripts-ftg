$folders = gci  -Directory
$foldersAmnt = ($folders | measure).Count


for ($i=0; $i -lt $foldersAmnt; $i++){
    cd $folders[$i]
    if (Test-Path Telegram.exe) {
       .\Telegram.exe
    }
    cd ../
}

