<#
Remove file:
Target Device
Note: For Provisioning Server 6.0 and beyond, BNNS driver is no longer used for Windows 7 and 2008, so this registry key is not applicable. However, BNNS is still used for windows XP and 2003.
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BNNS\Parameters\
DWORD = EnableOffload
Value: "0"
#>

function Disable-LargeSendOffloading
{
    <#
    .SYNOPSIS
        ToDo: Disables Offline Files which is recommended for always-on systems.

    .DESCRIPTION
        ToDo: The disabling of Offline Files is strongly recommended to prevent Windows from caching
        network files on its local disk – a feature with no benefit to a diskless system.

        Offline Files saves a copy of network files on the user's computer for use when the computer
        is not connected to the network.

        Note: Changes to this setting do not take effect until the affected computer is restarted.

    .EXAMPLE
        Disable-LargeSendOffloading

        ToDo: add example output

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Network, Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\BNNS\Parameters'
        Name         = 'EnableOffload'
        PropertyType = 'Dword'
        Value        = 0
    }

    if ($PSCmdlet.ShouldProcess('Disable Large Send Offload on the machine'))
    {
        New-ItemProperty @Params -Force | Out-Null
    }
}
