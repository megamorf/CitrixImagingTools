Function Set-Shortcut
{
    <#
    .SYNOPSIS
        Creates or overwrites file shortcuts (*.lnk).

    .DESCRIPTION
        Uses a com object to create a file shortcut The link might
        additionally specify parameters to be passed to the target
        program when it is run.

    .PARAMETER TargetPath
        Specify a path to the target program file/directory.

    .PARAMETER Arguments
        Specify optional arguments for the program under $TargetPath.

    .PARAMETER DestinationPath
        Path where the shortcut is going to be stored.

    .EXAMPLE
        ToDo: add examples

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Filesystem
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
