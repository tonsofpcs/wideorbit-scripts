# WideOrbit CD Tagger, original by Al Reynolds
# Updated 2019-06-16 Eric Adler
#region Variables
$CD_source_folder = "C:\CDAudio"
$wideorbit_CD_import_folder = "C:\IMPORT\CD"
$prefix = "PS"
$wo_clientID = [guid]::NewGuid()
$wo_clientID = "$env:computername---$wo_clientID" 
$wo_ip = "127.0.0.1"
$wo_uri = $wo_ip + "/ras/inventory"
#endregion
#region Import Loop
while ($true) {
    $wo_clientID = [guid]::NewGuid()
    $wo_clientID = "$env:computername---$wo_clientID" 
    $host.ui.RawUI.WindowTitle = "Content Depot Importer"
    Write-Host "WAITING FOR FILE..."
    $files = Get-ChildItem $CD_source_folder -File
    foreach ($file in $files) {
        $ContentDepotID = $file.BaseName
        $MediaAssetID = "$prefix$ContentDepotID"
        Write-Host "GO"
        $fullname = $file.FullName
        #ensure that file is not locked
            Try {
                [IO.File]::OpenWrite($fullname).Close()
                Break
            }
            Catch { 
                Write-Host "FILE LOCKED...SKIPPING"
                Continue
            }

        $destfile = "$wideorbit_CD_import_folder\$MediaAssetID.wav"
        Move-Item -Path $fullname -Destination $destfile 
        #wait for a import notification from WideOrbit
        $WOImportID = ""
        While ($WOImportID -ne $MediaAssetID) {
            $notification = Invoke-WebRequest -Method GET -uri "localhost/internal/notifications/InventoryNotificationTopic?clientId=Importer"
            
            $metadata = $notification.content
            $metadata = [xml]$metadata
            
            $wo_cartName = $metadata.distributionNotification.cartName
            
            $wo_category = $metadata.distributionNotification.category
            
            $WOImportID = "$wo_category$wo_cartName"
        }
        Write-Host "Imported and tagged $MediaAssetID..."
    }
    Write-Host "WAITING FOR FILE..."
    Start-Sleep -Seconds 5 
}
#endregion
