Function Set-Shortcut
{
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER TargetPath
    Parameter description

    .PARAMETER Arguments
    Parameter description

    .PARAMETER DestinationPath
    Parameter description

    .EXAMPLE
        ToDo: add examples

    .NOTES
        ToDo: add tags, author info
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [string]
        $TargetPath,

        [string]
        $Arguments,

        [string]
        $DestinationPath
    )

    if ($PSCmdlet.ShouldProcess("Link location: $DestinationPath, Command: [$TargetPath $Arguments]", 'Create Shortcut'))
    {
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($DestinationPath)
        $Shortcut.TargetPath = $TargetPath
        $Shortcut.Arguments = $Arguments
        $Shortcut.Save()
    }
}
