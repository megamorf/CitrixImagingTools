Function Get-AutoAdminLogon
{
    <#
    .SYNOPSIS
        Checks the registry for AutoAdmin logon settings.

    .DESCRIPTION
        Tests if a username and password for AutoAdmin logon is set
        and if the logon itself is actually enabled.

    .EXAMPLE
        Get-AutoAdminLogon

        Enabled Username Password
        ------- -------- --------
        False

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Credential
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [CmdletBinding()]
    param()

    # Get-ItemPropertyValue's ErrorAction parameter is broken
    # this workaround simply returns a null value in case of errors
    function Get-ItemPropertyValueSafe
    {
        param($Path, $Name)

        try
        {
            Get-ItemPropertyValue -Path $Path -Name $Name
        }
        catch
        {
            $null
        }
    }

    $Path = 'HKLM:\Software\Microsoft\Windows NT\Currentversion\WinLogon'

    $Enabled = [bool](Get-ItemPropertyValueSafe -Path $Path -Name AutoAdminLogon)
    $Username = Get-ItemPropertyValueSafe -Path $Path -Name DefaultUserName
    $Password = Get-ItemPropertyValueSafe -Path $Path -Name DefaultPassword | ForEach-Object {

        # the password is stored in the registry in clear text by default if not stored in LSA
        # we don't want to return a clear text password in the output so we return it as a
        # secure string if it set. If it's not set we just return nothing as password.
        if ($null -ne $_)
        {
            ConvertTo-SecureString -String $_ -AsPlainText -Force
        }
    }

    [PSCustomObject]@{
        Enabled  = $Enabled
        Username = $Username
        Password = $Password
    }
}
