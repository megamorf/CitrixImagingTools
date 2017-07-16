function Add-AutoAdminLogon
{
    <#
    .SYNOPSIS
        Enables the AutoAdmin Logon for the specified user credentials.

    .DESCRIPTION
        Enables the AutoAdmin Logon in the registry. Can optinally use the LSA Secret storage to prevent
        the auto logon user password in the registry in cleartext.

    .PARAMETER Credential
        Specifiy a PSCredential object of a domain user account.

    .PARAMETER UseLsaSecretStorage
        The Local Security Authority (LSA) in Windows is designed to manage a systems security policy,
        auditing, logging users on to the system, and storing private data such as service account passwords.

        LSA Secrets are a protected area of storage used to store internal private data.
        Data is stored in the registry under HKLM\SECURITY\Policy\Secrets, and this registry key
        has restricted ACL’s so it is not visible in regedit.exe using a normal user accounts.
        However, the DefaultPassword key can be decoded by any administrator using a simple Win32
        API call.

        This feature uses P/Invoke with Duplicate Process Tokens.

    .PARAMETER Force
        Specify to overwrite existing AutoAdmin Logon settings

    .EXAMPLE
        Add-AutoAdminLogon -Credential $(Get-Credential) -UseLsaSecretStorage -Verbose

        ToDo: add example output/more examples

    .NOTES
        ToDo: add tags, author info
    #>

    [Cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [switch] $UseLsaSecretStorage,

        [switch] $Force
    )

    if ($Credential.UserName -like "*\*" )
    {
        $Domain, $Username = $Credential.UserName.split('\')
    }
    elseif ($Credential.UserName -like "*@*")
    {
        $Username, $Domain = $Credential.UserName.split('@')
    }
    else
    {
        throw "Please provide a valid domain user"
    }

    $Path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

    # CHeck if there is an auto admin logon configured already
    # ToDo: add logic, eval force switch

    if ($PSCmdlet.ShouldProcess("Username=$Username,Domain=$Domain", 'Add AutoAdmin logon'))
    {
        Set-ItemProperty -Path $Path -Name 'AutoAdminLogon'    -Value '1'
        Set-ItemProperty -Path $Path -Name 'DefaultUserName'   -Value $Username
        Set-ItemProperty -Path $Path -Name 'DefaultDomainName' -Value $Domain

        if (-not $UseLsaSecretStorage.IsPresent)
        {
            Set-ItemProperty -Path $Path -Name 'DefaultPassword' -Value $Credential.GetNetworkCredential().Password
        }
        else
        {
            Add-LsaSecret # ToDo: add function and
        }

    }

}
