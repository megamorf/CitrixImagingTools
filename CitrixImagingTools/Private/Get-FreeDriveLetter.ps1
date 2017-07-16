Function Get-FreeDriveLetter
{
    <#
    .SYNOPSIS
        Returns a list of unassigned drive letters.

    .EXAMPLE
        Get-FreeDriveLetter

        A
        B
        E
        [output omitted]

        Returns all unassigned drive letters

    .EXAMPLE
        Get-FreeDriveLetter | Select -Last 1

        Z

        Returns only the last available drive letter.
    #>
    [OutputType([System.Collections.Arraylist])]
    [CmdletBinding()]
    param()

    # Build list of all drive letters and remove assigned letters from it
    $DriveLetters = [System.Collections.Arraylist][char[]]([char]'A'..[char]'Z')
    (Get-PSDrive -PSProvider FileSystem).Name | ForEach-Object { $DriveLetters.Remove([char]$_) }

    $DriveLetters
}
