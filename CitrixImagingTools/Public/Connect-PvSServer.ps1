function Connect-PvsServer
{
    [CmdletBinding()]
    param(
        $Computername,
        $Credential,
        [switch]$Persist
    )

    Add-PSSnapin -Name 'Citrix.PVS.SnapIn' -ErrorAction Stop
    
    $Connection = Get-PvsConnection

    $Params = @{
        PassThru = $true
        Persist = $Persist.IsPresent
    }

    if($Computername)
    {
        $Params.Server = $Computername
    }

    if($Credential)
    {
        $User = Split-DomainUsername -Name $Credential.Username
        $Params.User = $User.Name
        $Params.Domain = $User.Domain
        $Params.Password = $Credential.GetNetworkCredential().Password
    }

    Set-PvsConnection @Params -Verbose
}
