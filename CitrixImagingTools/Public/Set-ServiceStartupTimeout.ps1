Function Set-ServiceStartupTimeout
{
    <#
    .SYNOPSIS
        Increase/Decrease Service Startup Timeout

    .DESCRIPTION
        Helps with error 1053:

        ---
        The service did not respond in a timely fashion" when attempting to start, stop or pause a service
        ---

        When a service starts, the service communicates to the Service Control Manager how long the service
        must have to start (the time-out period for the service). If the Service Control Manager does not
        receive a "service started" notice from the service within this time-out period, the Service Control
        Manager terminates the process that hosts the service. This time-out period is typically less than
        30 seconds. If you do not adjust this time-out period, the Service Control Manager ends the process.

    .EXAMPLE
        Set-ServiceStartupTimeout
        
        Configures the default timeout of 30 seconds

    .EXAMPLE
        Set-ServiceStartupTimeout -Seconds 200
        
        Configures a custom timeout of 200 seconds

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Service
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param(
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0,999)]
        [int]$Seconds = 30
    )

    if ($PSCmdlet.ShouldProcess("$Seconds seconds", 'Set service timeout'))
    {
        $Params = @{
            Path = 'HKLM:\SYSTEM\CurrentControlSet\Control'
            Name = 'ServicesPipeTimeout'
            Value = $Seconds
        }

        Set-ItemProperty @Params
    }
}
