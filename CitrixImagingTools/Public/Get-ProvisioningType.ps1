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
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Runtime, State
    #>

    [OutputType([string])]
    [CmdletBinding()]
    param()

    try
    {
        $Params = @{
            Namespace = 'root\Citrix\DesktopInformation'
            ClassName = 'Citrix_VirtualDesktopInfo'
            Property  = 'ProvisioningType'
        }
        
        $Info = Get-CimInstance @Params
        
        switch ($Info.ProvisioningType)
        {
            'ProvisioningServices' { 'PVS'; break }
            'MachineCreationServices' { 'MCS'; break }
            default { 'Manual' }
        }

    }
    catch
    {
        throw "No Citrix VDA (MFA) agent found on the system!"
    }
}
