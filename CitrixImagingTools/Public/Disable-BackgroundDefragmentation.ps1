Function Disable-BackgroundDefragmentation
{
    <#
    .SYNOPSIS
        Disables Disk Defragmentation BootOptimizeFunction.

    .DESCRIPTION
        Not required for MCS or PVS based nonpersistent virtual desktops.
        File system changes are discarded after reboot.

        Disabling Automatic Disk Defragmentation prevents Window from filling the
        vDisk write cache by automatically defragmenting the vDisk during boot time.

    .EXAMPLE
        Disable-BackgroundDefragmentation

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Filesystem, Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path = 'HKLM:\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction'
        Name = 'Enable'
        Value = 'N'
    }

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable on-boot disk defragmentation'))
    {
        New-ItemProperty @Params -Force | Out-Null
    }
}
