Function Enable-TargetDeviceGetComputerNameFallback
{
    <#
    .SYNOPSIS
        Configures a fallback to computername instead of mac address if there's a
        problem with the bootstrap file.

    .DESCRIPTION
        From Citrix Discussions:
        What happens is if the name cannot be retrieved from the bootstrap then the
        name defaults to the mac address. You can force the target to ask again for
        the target's machine name by running this function.

    .EXAMPLE
        Enable-TargetDeviceGetComputerNameFallback

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Network, Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path         = 'HKLM:\System\CurrentControlSet\services\bnistack\Parameters'
        Name         = 'EnableGetComputerName'
        PropertyType = 'Dword'
        Value        = 1
    }

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Enable computer name fallback'))
    {
        New-ItemProperty @Params -Force | Out-Null
    }
}
