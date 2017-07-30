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

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: 
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

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable offline files on the machine'))
    {
        if ($false -eq (Test-Path -Path $Params.Path))
        {
            New-Item -Path $Params.Path -ItemType Directory -Force | Out-Null
        }

        New-ItemProperty @Params -Force | Out-Null
    }
}
