function Remove-CommonAutostart
{
    <#
    .SYNOPSIS
        Removes common Autostart files

    .DESCRIPTION
        Deletes files in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup.

        All files are deleted by default.

    .PARAMETER Filter
        Specify a file filter. Defaults to '*.*'.
        Wildcards are supported. Arrays of filters are not supported.

    .EXAMPLE
        Remove-CommonAutostart

        ToDo: add example output

    .NOTES
        ToDo: add tags, author info
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Filter = '*.*'
    )

    Write-Verbose -Message ("Removing files from Startup folder - Filter: $FileName" | AddPrefix)

    $CommonAutoStart = [System.Environment]::GetFolderPath("CommonStartup")

    Get-ChildItem -LiteralPath $CommonAutoStart -Force -Filter $Filter | ForEach-Object {
        try
        {
            Remove-Item -Path $_.FullName -ErrorAction Stop -Confirm:$False -Force -Verbose:$PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Verbose')
        }
        catch
        {
            Write-Warning -Message ("Error deleting file: $_, $($_.FullName)" | AddPrefix)
        }
    }
}
