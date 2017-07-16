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

    [CmdletBinding()]
    param(
        [string]
        $TargetPath,

        [string]
        $Arguments,

        [string]
        $DestinationPath
    )

    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($DestinationPath)
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.Arguments = $Arguments
    $Shortcut.Save()
}
