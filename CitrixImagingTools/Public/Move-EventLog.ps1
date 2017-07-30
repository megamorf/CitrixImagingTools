function Move-EventLog
{
    <#
    .SYNOPSIS
        Configures the path where event logs are stored.

    .DESCRIPTION
        The redirection of Event logs is strongly recommended to prevent Windows
        from needlessly filling up the write cache on PVS target devices.

        This is done by enumerating all event logs in the registry and changing
        their filesystem path to the specified destination.

    .PARAMETER Destination
        Path to where Event logs should be moved. It supports the batch environment
        variable notation in paths, e.g.: "%WriteCacheDisk%\EventLogs".

        In the registry the path value is stored in an ExpandString value to allow
        for environment variable based dynamic path expansion.

    .EXAMPLE
        Move-EventLog -Destination "%WriteCacheDisk%\EventLogs" -Verbose

        Sets "%WriteCacheDisk%\EventLogs" as filesystem location.

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Filesystem, Build
    #>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Destination))
    {
        $ExpandedDestinationPath = [System.Environment]::ExpandEnvironmentVariables($Destination)
        New-Item -Path $ExpandedDestinationPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
    }

    $EvtxLogs = Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\EventLog'
    $EvtxLogs | Add-Member -NotePropertyName Ext -NotePropertyValue '.evtx'

    $EvtLogs = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels'
    $EvtLogs | Add-Member -NotePropertyName Ext -NotePropertyValue '.evt'

    $count = 0
    $EventLogs = ($EvtxLogs + $EvtLogs)

    foreach ($EventLogKey in $EventLogs)
    {
        $count++
        $percent = [math]::Round(($count / $EventLogs.count * 100), 2)
        Write-Progress -Activity 'Redirect Eventlog...' -PercentComplete $percent -CurrentOperation "$percent% complete" -Status "$(Split-Path -Leaf -Path $EventLogKey.Name)"

        # Get keys and values
        $SubKey = Get-ItemProperty -Path $EventLogKey.PSPath

        # Get filesystem path to log from reg key
        if ($null -ne $SubKey.File)
        {
            # file value exists so use that
            $File = Split-Path -Leaf -Path $SubKey.File
        }
        else
        {
            # get file value from reg key, generate file extension
            # and replace illegal characters in path
            $File = Split-Path -Leaf -Path (($EventLogKey.Name + $EventLogKey.Ext) -replace '/', '%4')
        }

        Write-Verbose "Setting [$(Split-Path -Leaf -Path $EventLogKey.Name)] to [$(Join-Path $Destination $File)]"
        Set-ItemProperty -Path $SubKey.PSPath -Name File -Value (Join-Path $Destination $File) -Type ExpandString

        # Set additional flag for Windows > XP/2003 to actually apply the new path
        New-ItemProperty -Path $SubKey.PSPath -Name Flags -Value 1 -PropertyType dword -Force -ErrorAction SilentlyContinue
    }
}
