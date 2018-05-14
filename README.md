# wideorbit-scripts

Miscellaneous scripts for use with WideOrbit

## ContentDepotImporter.ps1

This script will move files from the CDCutID folder on your Content Depot recevier to a WideOrbit import directory, and prepend "CD" to all of the files names. You will need to create 10 Content Depot specific categories (CD0 through CD9), and configure a "If valid media asset" rule. I.E. ContentDepot Cut ID 60920 (Fresh Air Friday Billboard) will be imported as CD6/0920. 

### To use this Content Depot Importer

1. Download the script onto your WideOrbit Central Server (or any computer that has access to both your Content Depot receivers and your WideOrbit import folder). 
2. Edit the script to provide values for the Content Depot source folder--make sure you use the CDCutID folder. (i.e. \\192.168.1.20\xdcache\CDCutID)
3. Edit the script to provide values for the WideOrbit import folder. (i.e. \\wideorbit-cs\import\Content Depot)
4. Save and run the script. The script will automatically loop continuously. 

## ContentDepotTagger.ps1

This script will import files from Content Depot to WideOrbit, and set a custom metadata field with the Content Depot ID to facilitate a more natural integration between Content Depot and WideOrbit. 

### To use Content Depot Tagger

1. Create a new custom asset field:
    - Go to the WideOrbit Central Server configuration page
    - Under the "Inventory" tab on the left, click on the "Asset Fields" page
    - Click "Add Asset Field" and create a new Asset Field called "Content Depot ID"
    - Click "Submit"
2. Create the Content Depot categories in WideOrbit. You should create ten new categories: CD0 through CD9
3. Create a new Automatic Media Asset Importer  rule on your WideOrbit Central Server with the following settings:
    - Name: Content Depot Importer
    - "If File Name Is valid Media Asset number"
    - "Set Content Depot ID to CDIDHERE"
4. Create a new import directory for the Content Depot audio
5. Associate the "Content Depot Importer" rule with the import directory you just created
6. Download the Content Depot Tagger script onto your WideOrbit Central Server.
7. Edit the script to provide values for the Content Depot source folder--make sure you use the CDCutID folder. (i.e. \\192.168.1.20\xdcache\CDCutID)
8. Edit the script to provide a value for the WideOrbit import folder. (i.e. D:\Import\ContentDepot). 
9. Run the script


### Notes

- Please keep in mind that this script will MOVE the files from the CDCutID folder.
- I have only tested the ContentDepotTagger script 
- If you get a "script cannot be loaded because running scripts is disabled on this system" error, you will probably need to adjust your systems Powershell execution policy. 
- See https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1 for details.

## To-Do

- Toggle switch for custom metadata field tagging
- Support multiple custom metadata fields
- Script as a service
- Create installer

Cheers,
Al
