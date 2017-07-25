function Connect-PvsServer
{
    <#
    .SYNOPSIS
        Connects to a Citrix Provisioning Server (PVS).

    .DESCRIPTION
        Connects to a Citrix Provisioning Server (PVS) locally or
        remotely and with implicit or explicit credentials.

    .PARAMETER Computername
        Specify the IP address or the DNS name of the PVS server to
        which you want to connect.

    .PARAMETER Credential
        Specify a PSCredential object that contains credentials for
        authenticating with the server.

    .PARAMETER Persist
        Indicate that you want to save the specified credentials in
        the registry.

    .EXAMPLE
        Connect-PvsServer

        Connects to a local PVS server (localhost) using pass-through
        authentication.

    .EXAMPLE
        Connect-PvsServer -Computername srvpvs201

        Connects to a remote PVS server (srvpvs201) using pass-through
        authentication.

    .EXAMPLE
        Connect-PvsServer -Computername srvpvs201 -Credential $Cred

        Connects to a remote PVS server (srvpvs201) using the provided
        credentials.

    .EXAMPLE
        Connect-PvsServer -Computername srvpvs201 -Persist

        Connects to a remote PVS server (srvpvs201) using pass-through
        authentication and stores the connection settings in the registry.

    .NOTES
        Author: Sebastian Neumann (@megam0rf)
        Tags: Credential, PVS, RequiresSnapin
    #>

    [CmdletBinding()]
    param(

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("__Server", "IPAddress", "CN", "dnshostname")]
        [ValidateNotNullOrEmpty()]
        [string]$Computername,

        [Parameter(ValueFromPipelineByPropertyName = $true, Position = 1)]
        [Alias("RunAs")]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,

        [switch]$Persist
    )

    Add-PSSnapin -Name 'Citrix.PVS.SnapIn' -ErrorAction Stop

    $Params = @{
        PassThru = $true
        Persist  = $Persist.IsPresent
    }

    if ($Computername)
    {
        $Params.Server = $Computername
    }

    if ($Credential)
    {
        $User = Split-DomainUsername -Name $Credential.Username
        $Params.User = $User.Name
        $Params.Domain = $User.Domain
        $Params.Password = $Credential.GetNetworkCredential().Password
    }

    Set-PvsConnection @Params -Verbose
}
