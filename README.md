# wideorbit-scripts
Miscellaneous scripts for use with WideOrbit

## ContentDepotImporter.ps1
This script will move files from the CDCutID folder on your Content Depot recevier to a WideOrbit import directory, and prepend "CD" to all of the files names. You will need to create 10 Content Depot specific categories (CD0 through CD9), and configure a "If valid media asset" rule. I.E. ContentDepot Cut ID 60920 (Fresh Air Friday Billboard) will be imported as CD6/0920. 

### To use this script
1. Download the script onto your WideOrbit Central Server (or any computer that has access to both your Content Depot receivers and your WideOrbit import folder). 
2. Edit the script to provide values for the Content Depot source folder--make sure you use the CDCutID folder. (i.e. \\192.168.1.20\xdcache\CDCutID)
3. Edit the script to provide values for the WideOrbit import folder. (i.e. \\wideorbit-cs\import\Content Depot)
4. Save and run the script. The script will automatically loop continuously. 

### Notes
* Please keep in mind that this script will MOVE the files from the CDCutID folder.
* If you get a "script cannot be loaded because running scripts is disabled on this system" error, you will probably need to adjust your systems Powershell execution policy. 
* See https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1 for details.

Cheers,
Al
