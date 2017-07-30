function Disable-WindowsUpdate
{
    <#
    .SYNOPSIS
        Disables windows update searching/downloading.

    .DESCRIPTION
        The disabling of searching and downloading windows updates is strongly recommended
        to prevent Windows from caching update files on its local disk – a feature with no
        benefit to a diskless system.

        In addition the periodic update search can lead to high CPU utilization which is
        undesired on systems with logged on users.

    .EXAMPLE
        Disable-WindowsUpdate

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Sealing
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'
        PropertyType = 'Dword'
        Force = $true
    }

    if ($PSCmdlet.ShouldProcess('Disable automatic update searching & downloading'))
    {
        New-ItemProperty @Params -Name AUOptions -Value 1 | Out-Null
        New-ItemProperty @Params -Name ScheduledInstallDay -Value 0 | Out-Null
        New-ItemProperty @Params -Name ScheduledInstallTime -Value 3 | Out-Null
    }

    if ($PSCmdlet.ShouldProcess('Stop & disable windows update service'))
    {
        Stop-Service -Name wuauserv -PassThru | Set-Service -StartupType Disabled
    }
}
