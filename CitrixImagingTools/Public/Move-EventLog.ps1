function Move-EventLog
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$Destination
    )
    function Test-IsVistaOr2008OrAbove
    {
        If ((Get-WmiObject -Class Win32_OperatingSystem).BuildNumber -gt 7600)
        {
            return $true
        }
        return $false
    }

    if (-not (Test-Path -LiteralPath $Destination))
    {
        mkdir $Destination -Force -ErrorAction Stop | Out-Null
    }

    # Log-Extension bestimmen
    switch (Test-IsVistaOr2008OrAbove)
    {
        $True { $Ext = '.evtx'; $EventLogs = @(Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\EventLog' -ErrorAction Stop) }
        $False { $Ext = '.evt' ; $EventLogs = @(Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels' -ErrorAction Stop) }
    }

    # Validate inputs
    if (($EventLogs -isnot [array]) -or ($EventLogs[0] -isnot [Microsoft.Win32.RegistryKey]))
    {
        throw 'Wrong Input'
    }

    $count = 0

    # Durchlaufen
    foreach ($EventLogKey in $EventLogs)
    {
        $count++
        $percent = $count / $EventLogs.count * 100
        Write-Progress -Activity 'Ändere Eventlog-Speicherort...' -PercentComplete $percent -CurrentOperation "$percent% complete" -Status "$(Split-Path -Leaf -Path $EventLogKey.Name)"

        # Keys und Werte aus dem Schlüssel auslesen
        $SubKey = Get-ItemProperty -Path $EventLogKey.PSPath

        # # Dateisystempfad zum Log aus Registry Key auslesen
        if ($null -ne $SubKey.File)
        {
            # File ist gefüllt, also einfach auslesen
            $File = Split-Path -Leaf -Path $SubKey.File
        }
        else
        {
            # File aus dem Regschlüssel und Dateiendung generieren, vorher nicht erlaubte Pfadzeichen ersetzen
            $File = Split-Path -Leaf -Path (($EventLogKey.Name + $Ext) -replace '/', '%4')
        }

        Write-Verbose "Ändere [$(Split-Path -Leaf -Path $EventLogKey.Name)] auf [$(Join-Path $Destination $File)]"
        Set-ItemProperty -Path $SubKey.PSPath -Name File -Value (Join-Path $Destination $File) -Type ExpandString

        If (Test-IsVistaOr2008OrAbove)
        {
            Write-Verbose "Setze zusätzliches 'Flag' für Windows > XP/2003, damit neuer Pfad benutzt wird"
            New-ItemProperty -Path $SubKey.PSPath -Name Flags -Value 1 -PropertyType dword -ErrorAction SilentlyContinue
        }
    }

    Write-Progress -Activity 'Ändere Eventlog-Speicherort...' -Completed -Status 'All done.'
}
