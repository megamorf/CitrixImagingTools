function Test-Credential
{
    <#
    .SYNOPSIS
        Validates a credential against the local computer or
        Active Directory (default).

    .DESCRIPTION
        Validates a credential against the local computer or
        Active Directory (default).

        Returns true if validation was successful, or false.

    .PARAMETER Credential
        Specify a credential object that contains a username/
        password combination that should be validated.

    .PARAMETER Scope
        The validation scope.

        - domain (default)
        - machine

    .EXAMPLE
        Test-Credential -Credential "testuser"

        Interactively asks for testuser's password and validates
        the credentials against Active Directory.

    .EXAMPLE
        Test-Credential -Credential $Cred -Scope Machine

        Validates the credentials $cred of a local account against
        the local machine.

    .NOTES
        ToDo: add tags, author info
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential,

        [ValidateSet('Domain', 'Machine')]
        [string]
        $Scope = 'Domain'
    )

    if ([string]::IsNullOrEmpty($Credential.UserName))
    {
        throw "Username is empty! Aborting"
    }

    if ($Credential.UserName -match '(\\|@)')
    {
        Write-Verbose -Message ('Removing domain from Username' | AddPrefix)
        if ($Credential.UserName -like "*\*" )
        {
            $Username = $Credential.UserName.split('\')[-1]
        }
        elseif ($Credential.UserName -like "*@*")
        {
            $Username = $Credential.UserName.split('@')[0]
        }
        Write-Verbose -Message ("Username [$Username]" | AddPrefix)
    }
    else
    {
        $Username = $Credential.UserName
    }

    Add-Type -AssemblyName System.DirectoryServices.AccountManagement

    #switch ($Scope)
    #{
    #    'Domain' {$DS = [System.DirectoryServices.AccountManagement.PrincipalContext]::New($Scope); break}
    #    'Machine' {$DS = [System.DirectoryServices.AccountManagement.PrincipalContext]::New($Scope, $env:computername); break}
    #    Default {}
    #}

    $DS = [System.DirectoryServices.AccountManagement.PrincipalContext]::New($Scope)
    $DS.ValidateCredentials($Username, $Credential.GetNetworkCredential().Password)
}
