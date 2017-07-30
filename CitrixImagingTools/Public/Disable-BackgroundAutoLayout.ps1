Function Disable-BackgroundAutoLayout
{
    <#
    .SYNOPSIS
        Disables background auto-layout service.

    .DESCRIPTION
        The auto-layout service moves the most-used data closer to the center of the
        disk to expedite boot time. This service, if enabled, can cause unnecessary
        writes to the cache of non-persistent machines.

    .EXAMPLE
        Disable-BackgroundAutoLayout

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Build, Filesystem
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout'
        Name         = 'EnableAutoLayout'
        PropertyType = 'Dword'
        Value        = 0
    }

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable background auto-layout service'))
    {
        New-ItemProperty @Params -Force | Out-Null
    }
}

