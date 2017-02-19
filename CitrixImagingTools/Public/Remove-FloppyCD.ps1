Function Remove-FloppyCD
{
    [CmdletBinding()]
    param()

    Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -match '2|5' } | ForEach {
        Write-Verbose "Removing drive: $($_.DeviceID)"
        & mountvol.exe $_.DeviceID /D
    }
}
