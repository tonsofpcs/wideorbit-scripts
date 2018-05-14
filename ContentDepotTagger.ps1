#region Variables
$CD_source_folder = "C:\CDAudio"
$wideorbit_CD_import_folder = "C:\IMPORT\CD"
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
        start-sleep -Seconds 3
        #region set the Content Depot ID asset field
        #get the current metadata
        $GMA_Body = '<?xml version="1.0" encoding="UTF-8"?><getMediaAssetRequest version="1"><clientId>{0}</clientId><category>{1}</category><cartName>{2}</cartName></getMediaAssetRequest>' -f $wo_clientID,$wo_category,$wo_cartName
        $GMA_Reply = [xml](Invoke-WebRequest -Uri $wo_uri -Method POST -ContentType "text/xml" -Body $GMA_Body)
        #Set the Content Depot ID
        $GMA_Reply.getMediaAssetReply.mediaAsset.audioMetadata.metadata.value = "$ContentDepotID"
        #Update the media asset metadata
        $UMA_Body = "<?xml version=`"1.0`" encoding=`"utf-8`" standalone=`"yes`"?><updateMediaAssetRequest version=`"1`">$($GMA_Reply.getMediaAssetReply.mediaAsset.Outerxml)</updateMediaAssetRequest>"
        $UMA_Reply = [xml](Invoke-WebRequest -Uri $wo_uri -Method POST -ContentType "text/xml" -Body $UMA_Body)
        #endregion


        Write-Host "Imported and tagged $MediaAssetID..."
    }
    Write-Host "WAITING FOR FILE..."
    Start-Sleep -Seconds 5 
}
#endregion