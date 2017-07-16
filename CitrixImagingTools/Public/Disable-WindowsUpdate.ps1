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

        ToDo: add example output
    .NOTES
        ToDo: add tags, author info
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'

    if ($PSCmdlet.ShouldProcess('Disable automatic update searching & downloading'))
    {
        New-ItemProperty -Force -Path $Path -PropertyType Dword -Name AUOptions -Value 1
        New-ItemProperty -Force -Path $Path -PropertyType Dword -Name ScheduledInstallDay -Value 0
        New-ItemProperty -Force -Path $Path -PropertyType Dword -Name ScheduledInstallTime -Value 3
    }

    if ($PSCmdlet.ShouldProcess('Stop & disable windows update service'))
    {
        Stop-Service -Name wuauserv -PassThru | Set-Service -StartupType Disabled
    }
}
