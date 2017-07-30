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

    .PARAMETER AutoLogonCount
        Sets the number of times the system would reboot without asking for credentials.

    .PARAMETER VerifyCredential
        Tests against Active Directory if the provided credential are valid and throws an error
        if they're not correct.

    .EXAMPLE
        Add-AutoAdminLogon -Credential $(Get-Credential) -UseLsaSecretStorage -Verbose

        Sets up AutoAdminLogon with the provided credentials. Instead of storing the password
        in the registry in clear text it gets stored in the LSA secrets store which is a bit
        more secure.

    .EXAMPLE
        Add-AutoAdminLogon -Credential $Credential -VerifyCredential -Verbose

        Verifies the provided credentials against Active Directory before setting up the
        AutoAdminLogon. Aborts the process if the verification failed.

        The password is stored in the registry in cleartext since the -UseLsaSecretStorage
        switch was not provided.

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Credential, Account
    #>

    [Cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [switch] $UseLsaSecretStorage,

        [int] $AutoLogonCount

    )

    # We only care about domain users, so ensure the rest of the
    # function is only run if a domain was provided with the username
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

    # Ensures that the rest of the function is only run if the
    # username/password can be successfully tested against AD
    if ($VerifyCredential.IsPresent)
    {
        Write-Verbose -Message ("Username=$Username,Domain=$Domain", 'Verify Credentials')
        if ($false -eq (Test-Credential -Credential $Credential))
        {
            throw 'AD credential verification failed. Aborting...'
        }
    }

    $Path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

    if ($PSCmdlet.ShouldProcess("Username=$Username,Domain=$Domain", 'Add AutoAdmin logon'))
    {
        Set-ItemProperty -Path $Path -Name 'AutoAdminLogon'    -Value '1'
        Set-ItemProperty -Path $Path -Name 'DefaultUserName'   -Value $Username
        Set-ItemProperty -Path $Path -Name 'DefaultDomainName' -Value $Domain

        if ($AutoLogonCount)
        {
            New-ItemProperty -Path $Path -Name 'AutoLogonCount' -Value $AutoLogonCount -Type DWord -Force
        }

        if (-not $UseLsaSecretStorage.IsPresent)
        {
            Set-ItemProperty -Path $Path -Name 'DefaultPassword' -Value $Credential.GetNetworkCredential().Password
            Set-LsaSecret -Key 'DefaultPassword' -Value $null
        }
        else
        {
            Write-Warning -Message "Adding cleartext password to registry. Please consider using the '-UseLsaSecretStorage' switch."
            Set-LsaSecret -Key 'DefaultPassword' -Value $Credential.Password
            Remove-ItemProperty -Path $Path -Name 'DefaultPassword' -ErrorAction SilentlyContinue
        }
    }
}
