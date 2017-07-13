function Remove-CommonAutostart
{
<#
.Synopsis
   Removes common Autostart files
.DESCRIPTION
   Deletes all files in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup.
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$Filter = '*.*'
    )

    Write-Verbose "Removing files from Startup folder - Filter: $FileName"

    $CommonAutoStart = [System.Environment]::GetFolderPath("CommonStartup")

    Get-ChildItem -LiteralPath $CommonAutoStart -Force -Filter $Filter | ForEach-Object {
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
