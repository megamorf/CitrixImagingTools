function Get-ProvisioningType
{
    <#
    .SYNOPSIS
        Returns the provisioning type of a system.

    .DESCRIPTION
        Returns an error if no FMA service is found on the system.
        Otherwise returns one of the following:

        PVS    - if personality file contains a disk name
        MCS    - if personality file does not contain a disk name
        Manual - if no personality file is found

    .EXAMPLE
        Get-ProvisioningType

        PVS

    .NOTES
        ToDo: add tags, author info
    #>

    [OutputType([string])]
    [CmdletBinding()]
    param()

    # Check XA/XD agent installation
    [bool]$CitrixAgentInstalled = Get-Service -Name "BrokerAgent" -ErrorAction SilentlyContinue
    if (-not $CitrixAgentInstalled)
    {
        throw "No Citrix VDA (MFA) agent found on the system!"
    }

    try
    {
        if (Select-String -Path 'C:\Personality.ini' -Pattern ([regex]::Escape('$DiskName=')) -ErrorAction Stop)
        {
            return 'PVS'
        }
        else
        {
            return 'MCS'
        }
    }
    catch
    {
        'Manual'
    }
}
