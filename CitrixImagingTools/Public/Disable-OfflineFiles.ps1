function Disable-OfflineFiles
{
    <#
    
    The disabling of Offline Folders is strongly recommended to prevent Windows from caching network files on its local disk – a feature with no benefit to a diskless system

    Offline Files saves a copy of network files on the user's computer for use when the computer is not connected to the network. 
    Note: Changes to this setting do not take effect until the affected computer is restarted.
    #>

    $OfflineFileGPOSettings = @{
        Path         = 'HKLM:\Software\Policies\Microsoft\Windows\NetCache'
        Name         = 'Enabled'
        PropertyType = 'Dword'
        Value        = 0
    }
    
    New-ItemProperty @OfflineFileGPOSettings -Force
}
