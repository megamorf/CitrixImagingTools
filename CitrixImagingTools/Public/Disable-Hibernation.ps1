function Disable-Hibernation
{
    <#
    .SYNOPSIS
        Disables hibernation.

    .DESCRIPTION
        It's a general best practice to disable hibernation for
        virtual desktops and servers.

    .EXAMPLE
        Disable-Hibernation -Verbose

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable Hibernation'))
    {
        & powercfg.exe -HIBERNATE OFF
    }
}
