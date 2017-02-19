Function Get-FreeDriveLetter
{
    [CmdletBinding()]
    param()
    
    # Build list of all drive letters and remove assigned letters from it
    $DriveLetters = [System.Collections.Arraylist][char[]]([char]'A'..[char]'Z')
    (Get-PSDrive -PSProvider FileSystem).Name | ForEach-Object { $DriveLetters.Remove([char]$_) }

    $DriveLetters
}
