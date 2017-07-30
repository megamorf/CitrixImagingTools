function Disable-ClearPageFileAtShutdown
{
    <#
    .SYNOPSIS
        Disables clearing the paging file during the shutdown process.

    .DESCRIPTION
        Not required for MCS or PVS based nonpersistent virtual desktops.
        Clearing the page file increases shutdown times.

    .EXAMPLE
        Disable-ClearPageFileAtShutdown

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: 
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
        Name         = 'ClearPageFileAtShutdown'
        PropertyType = 'Dword'
        Value        = 0
    }

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable Clear Page File at Shutdown'))
    {
        New-ItemProperty @Params -Force | Out-Null
    }
}
