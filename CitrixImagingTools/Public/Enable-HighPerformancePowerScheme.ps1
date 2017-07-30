function Enable-HighPerformancePowerScheme
{
    <#
    .SYNOPSIS
        Enables the power scheme "High Performance"

    .DESCRIPTION
        Enables the power scheme "High Performance".

    .EXAMPLE
        Enable-HighPerformancePowerScheme -Verbose

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Build, Performance
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Enable High Performance power scheme'))
    {
        & powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    }
}
