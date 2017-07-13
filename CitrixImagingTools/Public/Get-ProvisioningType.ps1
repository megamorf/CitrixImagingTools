function Get-ProvisioningType
{
    [OutputType([string])]
    [CmdletBinding()]
    param()

    # Check XA/XD agent installation
    [bool]$CitrixAgentInstalled = Get-Service -Name "Spooler" -ErrorAction SilentlyContinue
    if (-not $CitrixAgentInstalled)
    {
        throw "No Citrix FMA agent found on the system!"
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