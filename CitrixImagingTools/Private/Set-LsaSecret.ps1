function Set-LsaSecret
{
    <#
    .SYNOPSIS
        Sets an LSA secret for a given key.

    .DESCRIPTION
        Uses the Local Security Authority (LSA) secret store
        to create or set the value of the specified key.

    .PARAMETER Key
        Specify the of the key to set the value for.

    .PARAMETER Value
        Specify a string (as SecureString) to store as value for the key.

    .EXAMPLE
        Set-LsaSecret -Key MyKey -Value $ValueAsSecureString

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Key,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [AllowEmptyString()]
        [AllowNull()]
        [SecureString]
        $Value
    )

    $LsaUtil = New-Object lsautil.lsautil -ArgumentList $Key
    try
    {
        if ($PSCmdlet.ShouldProcess("Key [$Key]", 'Set LSA secret'))
        {
            if ([string]::IsNullOrEmpty($Value))
            {
                $ClearTextValue = $Value
            }
            else
            {
                # Shortcut to convert securestring to string
                $ClearTextValue = [PSCredential]::New("user", $Value).GetNetworkCredential().Password
            }

            $LsaUtil.SetSecret($ClearTextValue)
        }
    }
    catch
    {
        $_
    }
}
