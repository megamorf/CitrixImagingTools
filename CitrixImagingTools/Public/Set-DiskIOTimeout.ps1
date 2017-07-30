function Set-DiskIOTimeout
{
    <#
    .SYNOPSIS
        Increase/Decrease disk IO Timeout.

    .DESCRIPTION
        In peak scenarios the disk may be heavily strained. This setting allows
        for a maxmimum timeout of 200 seconds.

    .EXAMPLE
        Set-DiskIOTimeout

        Configures the default timeout of 30 seconds

    .EXAMPLE
        Set-DiskIOTimeout -Seconds 200

        Configures a custom timeout of 200 seconds

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Service
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param(
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0,200)]
        [int]$Seconds = 30
    )

    if ($PSCmdlet.ShouldProcess("$Seconds seconds", 'Set disk IO timeout'))
    {
        $Params = @{
            Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\Disk'
            Name = 'TimeOutValue'
            Value = $Seconds
            PropertyType = 'Dword'
        }

        New-ItemProperty @Params -Force | Out-Null
    }
}
