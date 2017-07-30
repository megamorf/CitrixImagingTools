Function Disable-LastAccessTimestamp
{
    <#
    .SYNOPSIS
        Disables the filesystem last access timestamps.
    .DESCRIPTION
        Disabling the last access timestamp will help to minimize I/O operations.
    .EXAMPLE
        Disable-LastAccessTimestamp
    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Build, Filesystem
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable the filesystem last access timestamps'))
    {
        & fsutil behavior set disablelastaccess 1 | Out-Null
    }
}
