function Start-Defragmentation
{
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER DriveLetter
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    [cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 2)]
        [string]
        $DriveLetter
    )

    # Clean up drive letter in case the string contains a ':'
    [string]$DriveLetter = $DriveLetter[0]

    switch -wildcard ([environment]::OSVersion.Version.ToString())
    {
        '6.1*' { $defragargs = "/H /U /V"; break }
        '6.2*' { $defragargs = "/H /K"; break }
        '6.3*' { $defragargs = "/H /K /G"; break }
        default { $defragargs = "/U" }
    }

    Write-Verbose -Message ("Starting defrag" | AddPrefix)

    if ($PSCmdlet.ShouldProcess("Defragment drive $DriveLetter", "Arguments: $defragargs"))
    {
        Start-Process defrag.exe -ArgumentList $DriveLetter, $defragargs -Wait
    }

    Write-Verbose -Message ("Defrag complete" | AddPrefix)
}
