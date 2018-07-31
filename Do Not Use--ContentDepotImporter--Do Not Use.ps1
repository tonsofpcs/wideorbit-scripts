#region Variables
$CD_source_folder = ""
$wideorbit_CD_import_folder = ""
#endregion
#region Import Loop
while ($true) {
    $host.ui.RawUI.WindowTitle = "Content Depot Importer"
    Write-Host "WAITING FOR FILE..."
    $files = Get-ChildItem $CD_source_folder -File
    foreach ($file in $files) {
    Write-Host "GO"
        $fullname = $file.FullName
        $name = $file.Name
        #ensure that file is not locked
        While ($True) {
            Try {
                [IO.File]::OpenWrite($fullname).Close()
                Break
            }
            Catch { 
                Write-Host "FILE LOCKED...WAITING"
                Start-Sleep -Seconds 1
            }
        }

        $destfile = "$wideorbit_CD_import_folder\CD$name"
        Move-Item -Path $fullname -Destination $destfile 
        #wait for WO to begin ingesting the file
        While ($True) {
            Try {
                [IO.File]::OpenWrite($destfile).Close()
                Break
            }
            Catch { 
                Write-Host "FILE LOCKED...WAITING"
                Start-Sleep -Seconds 1
            }
        }
        Write-Host "FILE IS BEING PROCESSED..."
    }
    Write-Host "WAITING FOR FILE..."
    Start-Sleep -Seconds 5 
}
#endregion
