function Remove-CommonDesktopShortcut
{
    <#
    .SYNOPSIS
        Removes common Desktop links

    .DESCRIPTION
        Deletes all *.lnk files in C:\Users\Public\Desktop.

    .EXAMPLE
        Remove-CommonDesktopShortcut

        ToDo: add example output

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Filesystem, Cleanup, Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    Param()

    $CommonDesktop = [System.Environment]::GetFolderPath("CommonDesktopDirectory")

    Get-ChildItem $CommonDesktop -Filter *.lnk -Force | ForEach-Object {
        try
        {
            Remove-Item -Path $_.FullName -ErrorAction Stop -Confirm:$False -Force -Verbose:$PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Verbose')
        }
        catch
        {
            Write-Warning "Error deleting file: $_, $($_.FullName)"
        }
    }
}
