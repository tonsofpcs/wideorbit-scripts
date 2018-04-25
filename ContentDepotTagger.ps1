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
        $ContentDepotID = $file.BaseName
        $MediaAssetID = "CD$ContentDepotID"
    Write-Host "GO"
        $fullname = $file.FullName
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

        $destfile = "$wideorbit_CD_import_folder\$MediaAssetID"
        Move-Item -Path $fullname -Destination $destfile 
        #wait for a import notification from WideOrbit
        While ($WOImportID -ne $MediaAssetID) {
            $notification = Invoke-WebRequest -Method GET -uri "wideorbit/internal/notifications/InventoryNotificationTopic?clientId=Importer"
            $metadata = $notification.content
            $metadata = [xml]$metadata
            $WOcartName = $metadata.distributionNotification.cartObject
            $WOcategory = $metadata.distributionNotification.category
            $WOImportID = "$WOcategory$WOcartName"
        }
        #set the Content Depot ID asset field
        


        Write-Host "FILE IS BEING PROCESSED..."
    }
    Write-Host "WAITING FOR FILE..."
    Start-Sleep -Seconds 5 
}
#endregion
