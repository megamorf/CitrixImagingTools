function Optimize-WindowsUpdate
{
    <#
    .SYNOPSIS
        Runs an online DISM image cleanup.

    .DESCRIPTION
        Uses the following command:

        Dism /Online /Cleanup-Image {/StartComponentCleanup [/ResetBase]}

        Cleans up the superseded components and reduces the size of the component store.
        Use /ResetBase to reset the base of superseded components, which can further reduce
        the component store size. Installed Windows updates can’t be uninstalled after running
        /StartComponentCleanup with the /ResetBase option.

        A log can be found under "$env:temp\dism-cleanup.log".

    .EXAMPLE
        Optimize-WindowsUpdate

        ToDo: add example output

    .NOTES
        ToDo: add tags, author info

    .Link
        https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-operating-system-package-servicing-command-line-options
    #>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param()

    if ($PSCmdlet.ShouldProcess('Run DISM cleanup'))
    {
        & Dism.exe /Online /LogPath:"$env:temp\dism-cleanup.log" /Cleanup-Image /StartComponentCleanup /ResetBase
        if ($LASTEXITCODE)
        {
            throw 'Dism.exe cleanup failed'
        }
    }
}
