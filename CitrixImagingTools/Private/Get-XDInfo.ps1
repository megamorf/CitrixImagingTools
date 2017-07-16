function Get-XDInfo
{
    [OutputType([pscustomobject])]
    [CmdletBinding()]

    $VersionTable = @{
        XDVersion    = ""
        XDEdition    = ""
        BuildVersion = ""
        Site         = ""
        Controllers  = ""
    }

    $VersionTable
}
