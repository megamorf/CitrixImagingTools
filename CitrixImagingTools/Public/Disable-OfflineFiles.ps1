function Disable-OfflineFiles
{
    <#
    
The disabling of Offline Folders is strongly recommended to prevent Windows from caching network files on its local disk – a feature with no benefit to a diskless system
    #>

    $OfflineFileGPOSettings = @{
        Path = 
        Name = 
        Value = 
        
    }
    
    Set-ItemProperty @OfflineFileGPOSettings
}