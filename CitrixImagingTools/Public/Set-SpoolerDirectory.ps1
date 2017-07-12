Function Set-SpoolerDirectory
{
    # create redirected Spool directory

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Default')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(ParameterSetName = 'RestoreDefaultPath')]
        [switch]
        $RestoreDefaultPath
    )

    if ($RestoreDefaultPath)
    {
        $Path = "$env:Windir\system32\spool\PRINTERS"
    }

    if (-not(Test-Path -LiteralPath $Path))
    {
        New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop | Out-Null
    }

    SpoolerParams = @{
        Path  = 'HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers'
        Name  = 'DefaultSpoolDirectory'
        Value = $Path
    }

    Set-ItemProperty @SpoolerParams -ErrorAction Stop

    if ((Get-Service -Name Spooler).Status -eq 'Running')
    {
        Restart-Service -Name Spooler -Force
    }
}
