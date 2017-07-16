function Disable-ClearPageFileAtShutdown
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
        Disable-ClearPageFileAtShutdown

        ToDo: add example output

    .NOTES
        ToDo: add tags, author info
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
        Name         = 'ClearPageFileAtShutdown'
        PropertyType = 'Dword'
        Value        = 0
    }

    if ($PSCmdlet.ShouldProcess('Disable Clear Page File at Shutdown'))
    {
        Set-ItemProperty @Params -Force
    }
}
