Function Test-PvsConnection
{
    <#
    .SYNOPSIS
        Tests if there is an active PVS connection.

    .DESCRIPTION
        Returns $true if we are connected to a PVS server or
        throws an error if we're not.

    .EXAMPLE
        Test-PvsConnection

    .NOTES
        Author: Sebastian Neumann (@megam0rf)
        Tags: PVS, State, RequiresSnapin
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param()

    Add-PSSnapin -Name 'Citrix.PVS.SnapIn' -ErrorAction Stop
    $IsConnected = (Get-PvsConnection).Connected

    if (-not $IsConnected)
    {
        throw "You are not currently connected to any servers. Please connect first using the Connect-PvsServer command."
    }
    else
    {
        $true
    }
}
