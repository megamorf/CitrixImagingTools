function Split-DomainUsername
{
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
