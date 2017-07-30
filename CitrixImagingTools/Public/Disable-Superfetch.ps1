function Disable-Superfetch
{
    <#
    .SYNOPSIS
        Disables the Superfetch service.

    .DESCRIPTION
        Disables Superfetch by turning off its service.

        Superfetch tries to improve system performance over time by "learning" the
        typical user activity. This information is stored within the operating system,
        which means it is deleted upon each reboot and provides little value in a virtual
        desktop environment.

        Windows 8/8.1 should disable the SuperFetch service automatically in pooled virtual
        desktops.

    .EXAMPLE
        Disable-Superfetch

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable Superfetch'))
    {
        Stop-Service -Name sysmain -Force -PassThru | Set-Service -StartupType Disabled
    }
}
