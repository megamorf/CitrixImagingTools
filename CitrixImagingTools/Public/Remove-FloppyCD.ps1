Function Remove-FloppyCD
{
    <#
    .SYNOPSIS
        Unassign drive letters from CD & floppy drives.

    .DESCRIPTION
        Media drives are known to increase user logon times.
        It's recommended to remove them from the machine (either
        logically or better physically).

    .EXAMPLE
        Remove-FloppyCD

        ToDo: add example output

    .NOTES
        ToDo: add tags, author info
    #>
    [CmdletBinding()]
    param()

    Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -match '2|5' } | ForEach-Object {
        Write-Verbose -Message ("Removing drive: $($_.DeviceID)" | AddPrefix)
        & mountvol.exe $_.DeviceID /D
    }
}
