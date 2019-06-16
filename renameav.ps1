#variable def
$convcsv = "AVConvRpt.csv"
$csvname = "Promorename.csv"
#start
$csvin = Import-Csv $convcsv
$csvout = Import-Csv $csvname
foreach ($cut in $csvin) {
   $infile = $cut.BADID + ".wav"
   $outfile = $cut.AVID + ".wav"
   Write-Host "$infile to $outfile"
   Rename-Item $infile $outfile
   Write-Host "Renamed1"
}

foreach ($cut in $csvout) {
   $infile = $cut.AVID + ".wav"
   $outfile = $cut.WOID + ".wav"
   Write-Host "$infile to $outfile"
   Rename-Item $infile $outfile
   Write-Host "Renamed2"
}