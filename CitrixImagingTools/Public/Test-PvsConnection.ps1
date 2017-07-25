Function Test-PvsConnection
{
    [CmdletBinding()]
    param()

    Add-PSSnapin -Name 'Citrix.PVS.SnapIn' -ErrorAction Stop
    $IsConnected = (Get-PvsConnection).Connected

    if(-not $IsConnected)
    {
        throw "You are not currently connected to any servers. Please connect first using the Connect-PvsServer command."
    }
    else
    {
        $true
    }
}
