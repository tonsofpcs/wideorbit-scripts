# WideOrbit CD Tagger, original by Al Reynolds
# Updated 2019-06-16 - 2019-06-23 Eric Adler, allows for prefix, checks for last-change
#region Variables
$CD_source_folder = "X:\"
$wideorbit_CD_import_folder = "E:\CAT_IMPORT\PRX"
$prefix = "PX"
$wo_clientID = [guid]::NewGuid()
$wo_clientID = "$env:computername---$wo_clientID" 
$wo_ip = "127.0.0.1"
$wo_uri = $wo_ip + "/ras/inventory"
#endregion
#region Import Loop
while ($true) {
    $wo_clientID = [guid]::NewGuid()
    $wo_clientID = "$env:computername---$wo_clientID" 
    $host.ui.RawUI.WindowTitle = "PRX Importer"
    Write-Host "WAITING FOR FILE..."
    $files = Get-ChildItem $CD_source_folder -File
    foreach ($file in $files) {
		Write-Host $file.BaseName
        $ContentDepotID = $file.BaseName
        $MediaAssetID = "$prefix$ContentDepotID"
        $newfilename = "$prefix$file"
        Write-Host "GO"
        $fullname = $file.FullName
        #ensure that file is not locked
            $checkbad = $True
            While ($checkbad) {
                Write-Host "." -NoNewline
                $threshold = (Get-Date).AddMinutes(-1)
                if ((Get-Item "$CD_source_folder$file").LastWriteTime -lt $threshold) {
                    $checkbad = $False
                }
                If ($checkbad) {
                    Start-Sleep -Seconds 60
                }
            }
            Try {
                [IO.File]::OpenWrite($fullname).Close()
            }
            Catch { 
                Write-Host "FILE LOCKED...SKIPPING"
                Continue
            }

        $destfile = "$wideorbit_CD_import_folder\$newfilename" #$MediaAssetID.wav"
        Move-Item -Path $fullname -Destination $destfile 
        #wait for a import notification from WideOrbit
        $WOImportID = ""
#		Write-Host "Wait for notification"
#        While ($WOImportID -ne $MediaAssetID) {
#			Write-Host -NoNewLine "."
#            $notification = Invoke-WebRequest -Method GET -uri "localhost/internal/notifications/InventoryNotificationTopic?clientId=Importer"
#            
#            $metadata = $notification.content
#            $metadata = [xml]$metadata
#            Write-Host $metadata
#            $wo_cartName = $metadata.distributionNotification.cartName
#            
#            $wo_category = $metadata.distributionNotification.category
#            
#            $WOImportID = "$wo_category$wo_cartName"
#			Write-Host "ID $WOImportID"
 #       }
        start-sleep -Seconds 3
#        #region set the Content Depot ID asset field
#        #get the current metadata
#        $GMA_Body = '<?xml version="1.0" encoding="UTF-8"?><getMediaAssetRequest version="1"><clientId>{0}</clientId><category>{1}</category><cartName>{2}</cartName></getMediaAssetRequest>' -f $wo_clientID,$wo_category,$wo_cartName
#        $GMA_Reply = [xml](Invoke-WebRequest -Uri $wo_uri -Method POST -ContentType "text/xml" -Body $GMA_Body)
#        #Set the Content Depot ID
#        $GMA_Reply.getMediaAssetReply.mediaAsset.audioMetadata.metadata.value = "$ContentDepotID"
#        #Update the media asset metadata
#        $UMA_Body = "<?xml version=`"1.0`" encoding=`"utf-8`" standalone=`"yes`"?><updateMediaAssetRequest version=`"1`">$($GMA_Reply.getMediaAssetReply.mediaAsset.Outerxml)</updateMediaAssetRequest>"
#        $UMA_Reply = [xml](Invoke-WebRequest -Uri $wo_uri -Method POST -ContentType "text/xml" -Body $UMA_Body)
#        #endregion
#
#        Write-Host "Imported and tagged $MediaAssetID"
#		Write-host "GMA: $GMA_Reply.getMediaAssetReply.mediaAsset.audioMetadata.metadata.value"
#		Write-host "UMA: $UMA_Reply.getMediaAssetReply.mediaAsset.audioMetadata.metadata.value"
    }
    Write-Host "WAITING FOR FILE..."
    Start-Sleep -Seconds 5 
}
#endregion
