function Disable-OfflineFiles
{
    <#
    .SYNOPSIS
        Disables Offline Files which is recommended for always-on systems.

    .DESCRIPTION
        The disabling of Offline Files is strongly recommended to prevent Windows from caching
        network files on its local disk – a feature with no benefit to a diskless system.

        Offline Files saves a copy of network files on the user's computer for use when the computer
        is not connected to the network.

        Note: Changes to this setting do not take effect until the affected computer is restarted.

    .EXAMPLE
        Disable-OfflineFiles

        ToDo: add example output

    .NOTES
        ToDo: add tags, author info
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path         = 'HKLM:\Software\Policies\Microsoft\Windows\NetCache'
        Name         = 'Enabled'
        PropertyType = 'Dword'
        Value        = 0
    }

    if ($PSCmdlet.ShouldProcess('Disable offline files on the machine'))
    {
        New-ItemProperty @Params -Force
    }
}
