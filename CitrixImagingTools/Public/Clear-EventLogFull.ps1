function Clear-EventLogFull
{
    <#
    .SYNOPSIS
        Clears all event logs on a system.

    .DESCRIPTION
        It's useful to clear the logs of a golden master server before
        imaging.

    .EXAMPLE
        Clear-EventLogFull

    .NOTES
        ToDo: Add tags, author info
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param()

    $EventLogs = & wevtutil.exe enum-logs

    if ($PSCmdlet.ShouldProcess("$($EventLogs.Count) Logs", "Clear Event log"))
    {
        $Eventlogs.Foreach( {
                Write-Verbose -Message ("Clearing log: $_" | AddPrefix)
                & wevtutil clear-log "$_"
            })
    }
}
