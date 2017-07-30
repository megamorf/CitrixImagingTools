Function Disable-SystrayIcon
{
    <#
    .SYNOPSIS
        Removes specific icons from the systray.

    .DESCRIPTION
        We don't want specific infrastructure tools to appear in the systray
        for regular users. This functions helps with getting rid of those.

    .PARAMETER Icon
        Specify one or more icons to remove.

    .PARAMETER All
        Use this switch to remove all icons:

        - VMwareTools
        - PvsDisk

    .EXAMPLE
        Disable-SystrayIcon -Icon VMwareTools -Verbose

        Hides the VMware Tools icon from the systray.

    .EXAMPLE
        Disable-SystrayIcon -All -Verbose

        Hides the VMware Tools and PVS vDisk icon from
        the systray.

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Build,
    #>

    [CmdletBinding(DefaultParameterSetName = 'CustomSelection', SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'CustomSelection')]
        [ValidateSet('VMwareTools', 'PVSvDisk')]
        $Icon,

        [Parameter(ParameterSetName = 'All')]
        [switch]$All
    )

    if ($All.IsPresent -or 'VMwareTools' -in $Icon)
    {
        $VMwareToolsParams = @{
            Path  = 'HKLM:\SOFTWARE\VMware, Inc.\VMware Tools'
            Name  = 'ShowIcon'
            Value = 0
        }

        if ($PSCmdlet.ShouldProcess('VMwareTools', 'Remove systray icon'))
        {
            Set-ItemProperty @VMwareToolsParams -Force
        }

    }

    if ($All.IsPresent -or 'PVSvDisk' -in $Icon)
    {
        $PVSvDiskParams = @{
            Path  = 'HKLM:\Software\Citrix\ProvisioningServices\StatusTray'
            Name  = 'ShowIcon'
            Value = 0
        }

        if ($PSCmdlet.ShouldProcess('PvsDisk', 'Remove systray icon'))
        {
            # ToDo: Path cannot be found
            Set-ItemProperty @PVSvDiskParams -Force
        }
    }
}
