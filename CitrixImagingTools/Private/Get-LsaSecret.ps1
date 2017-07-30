function Get-LsaSecret
{
    <#
    .SYNOPSIS
        Returns an LSA secret for a given key.

    .DESCRIPTION
        Queries the Local Security Authority (LSA) secret store
        to retrieve the value of the specified key.

    .PARAMETER Key
        Name of the key to retrieve the value of.

        Returns null if the key value is empty or a warning if
        no key with the specified name can be found.

    .EXAMPLE
        $Secret = Get-LsaSecret -Key MyKey

        The key value is returned as secure string.

        Note: In order to get a cleartext representation of the string
              take the following approach:

        $UnsecureString = [PSCredential]::New("user",$Secret.Value).GetNetworkCredential().Password

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [OutputType([system.security.securestring])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Key
    )

    $LsaUtil = New-Object lsautil.lsautil -ArgumentList $Key
    try
    {
        $Value = $LsaUtil.GetSecret()
        if ([string]::IsNullOrEmpty($Value))
        {
            return
        }
        else
        {
            [pscustomobject]@{
                Key   = $Key
                Value = ($Value | ConvertTo-SecureString -AsPlainText -Force)
            }
        }
    }
    catch
    {
        if ($_.exception.message -like '*"RetrievePrivateData failed: 2"*')
        {
            Write-Warning -Message "Key $Key not found"
        }
    }
}
