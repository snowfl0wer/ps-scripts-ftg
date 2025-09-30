#unrar
$unrarPath = "C:\Program Files\WinRAR\UnRAR.exe"
function unrar {
    param(
        [string]$rarFile,
        [string]$destinationFolder
    )


    #handle errors here (if no file, if no destination folder)

    & $unrarPath x -y "$rarFile" "$destinationFolder"

    #check exit code, write a message

}

#count amount of new telegrams
$newTgsAmnt = (gci -Path NewTelegrams -File | measure).Count

#extract telegram portable
$tportableZip = gci -Filter *tportable*.zip
Expand-Archive $tportableZip -DestinationPath telegram-empty

#start telegram process 
$tgExe = gci -Path telegram-empty -Filter telegram.exe -Recurse

$tgProcess = start -FilePath $tgExe.FullName -PassThru 

#kill telegram process
$timeout = (Get-Date).AddSeconds(30)
while(-not (Test-Path telegram-empty/Telegram/tdata) ){
    sleep -Milliseconds 500
    if((Get-Date) -ge $timeout){
        exit
    }
}

kill -Id $tgProcess.Id

#copy telegram folder to an output folder a needed amnt of times
mkdir Output


for ($i = 1; $i -le $newTgsAmnt; $i++) {
    cp -Path telegram-empty/Telegram -Destination Output/$i -Force -Recurse
}

#unrar all new telegram archives 
$newTgRars = gci newTelegrams -Filter *.rar

cd NewTelegrams

for ($i=0; $i -lt $newTgsAmnt; $i++) {
    unrar $newTgRars[$i]
}

rm $newTgRars

cd ../

$newTgsTdata = gci -Path NewTelegrams -Directory -Recurse -Filter "tdata"
$outputTgs = gci -Path Output -Directory

#move new tgs tdata to corresponding telegram folders
for($i = 0; $i -lt $newTgsAmnt; $i++) {
    cp -Path $newTgsTdata[$i].FullName -Destination $outputTgs[$i].FullName -Recurse -Force
}

