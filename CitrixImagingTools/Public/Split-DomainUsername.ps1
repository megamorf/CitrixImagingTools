function Split-DomainUsername
{
    <#
    .SYNOPSIS
       Splits a username string into domain and username.

    .DESCRIPTION
        The Split-DomainUsername command returns the username and domain of
        a specified username string. Returns $null if the name does not match
        the following patterns:

        <domain>\<username>
        <username>@<domain>

    .PARAMETER Name
        Specifies the name to be split. You can also pipe a name to this command.

    .EXAMPLE
        Split-DomainUsername -Name '<domain>\<username>'

        Name       Domain
        ----       ------
        <username> <domain>

    .EXAMPLE
        Split-DomainUsername -Name '<username>@<domain>'

        Name       Domain
        ----       ------
        <username> <domain>

    .NOTES
        Author: Sebastian Neumann (@megam0rf)
        Tags:
    #>

    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    if ($Name -match '(\\|@)')
    {
        if ($Name -like "*\*" )
        {
            $Domain,$Username = $Name.split('\')
        }
        elseif ($Name -like "*@*")
        {
            $Username,$Domain = $Name.split('@')
        }

        Write-Verbose -Message ("Username [$Username], Domain [$Domain]" | AddPrefix)

        [pscustomobject]@{
            Name = $Username
            Domain = $Domain
        }
    }
}
