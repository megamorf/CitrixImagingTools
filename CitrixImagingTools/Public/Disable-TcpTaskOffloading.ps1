function Disable-TcpTaskOffloading
{
    <#
    .SYNOPSIS
        ToDo: Disables Offline Files which is recommended for always-on systems.

    .DESCRIPTION
       TCP offload engine is a function used in network interface cards (NIC) to offload
       processing of the entire TCP/IP stack to the network controller. By moving some or
       all of the processing to dedicated hardware, a TCP offload engine frees the system's
       main CPU for other tasks. However, TCP offloading has been known to cause some issues,
       and disabling it can help avoid these issues.

       This function disables all of the task offloads from the TCP/IP stack.

    .EXAMPLE
        Disable-TcpTaskOffloading

    .LINK
        https://docs.microsoft.com/en-us/windows-hardware/drivers/network/using-registry-values-to-enable-and-disable-task-offloading

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags:
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $Params = @{
        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        Name         = 'DisableTaskOffload'
        PropertyType = 'Dword'
        Value        = 1
    }

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable TCP/IP task offload on the machine'))
    {
        New-ItemProperty @Params -Force | Out-Null
    }
}
