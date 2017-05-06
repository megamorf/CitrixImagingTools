function Start-Defragmentation
{
    [cmdletbinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $DriveLetter
    )

    switch -wildcard ((Get-OSVersion).Version)
    {
        '6.1*' { $defragargs = "/H /U /V"; break }
        '6.2*' { $defragargs = "/H /K"; break }
        '6.3*' { $defragargs = "/H /K /G"; break }
        default { $defragargs = "/U" }
    }

    Write-Verbose "Starting defrag"
    Start-Process defrag.exe -ArgumentList $DriveLetter, $defragargs -PassThru
    Write-Verbose "Defrag complete"
}
