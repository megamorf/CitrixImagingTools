Function Optimize-SMBv2
{
    <#
    .SYNOPSIS
        Optimizes SMBv2 settings.

    .DESCRIPTION
        Tweaks the following settinga:

        - By default, the SMB redirector throttles throughput across high-latency network connections
        in some cases to avoid network-related timeouts. Setting the DisableBandwidthThrottling
        registry value to 1 disables this throttling, enabling higher file transfer throughput over
        high-latency network connections.

        - By default, the SMB redirector does not transfer payloads larger than approximately 64 KB per
        request. Setting the DisableLargeMtu registry value to 0 enables larger request sizes, which
        can improve file transfer speed.

        - By default, Change Notify events are turned on for file and folder changes that occur in
        subfolders of a mapped network share. Disable these events causes the server to still send a
        Change Notify event when a file or a folder is changed in the root and first folder level of
        the mapped network share. However the server does not send a Change Notify event when a change
        is made at the level of the second subfolder or deeper in the mapped network share.

    .EXAMPLE
        Optimize-SMBv2

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Network, Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        PropertyType = 'Dword'
        Force = $true
    }

    if ($PSCmdlet.ShouldProcess('SMB Redirector', 'Tweak settings'))
    {        
        $Path = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'

        New-ItemProperty @Params -Path $Path -Name DisableBandwidthThrottling -Value 1 | Out-Null
        New-ItemProperty @Params -Path $Path -Name DisableLargeMtu -Value 0 | Out-Null
    }


    if ($PSCmdlet.ShouldProcess('Change Notify Events', 'Disable'))
    {     
        $Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'

        New-ItemProperty @Params -Path $Path -Name NoRemoteRecursiveEvents -Value 1 | Out-Null
    }
}
