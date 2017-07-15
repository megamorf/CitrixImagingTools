Function Disable-SystrayIcon
{
    [CmdletBinding(DefaultParameterSetName='All',SupportsShouldProcess=$true)]
    param(
        [Parameter(ParameterSetName='CustomSelection')]
        [ValidateSet('VMwareTools','PVSvDisk')]
        $Icon,

        [Parameter(ParameterSetName='All')]
        [switch]$All
    )

    if ($All.IsPresent -or 'VMwareTools' -in $Icon)
    {
        
        $VMwareToolsParams = @{
            Path = 'HKLM:\SOFTWARE\VMware, Inc.\VMware Tools'
            Name = 'ShowIcon'
            Value = 0 
        }
        
        Set-ItemProperty @VMwareToolsParams -Force
    }

    if ($All.IsPresent -or 'PVSvDisk' -in $Icon)
    {
        
        $PVSvDiskParams = @{
            Path = 'HKLM:\Software\Citrix\ProvisioningServices\StatusTray'
            Name = 'ShowIcon'
            Value = 0 
        }

        Set-ItemProperty @PVSvDiskParams -Force
    }
}
