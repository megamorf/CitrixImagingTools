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
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Build
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object DriveType -match '2|5' | ForEach-Object {
        if ($PSCmdlet.ShouldProcess("Drive letter $($_.DeviceID)", 'Remove device'))
        {
            Write-Verbose -Message ("Removing drive: $($_.DeviceID)" | AddPrefix)
            & mountvol.exe $_.DeviceID /D
        }
    }
}
