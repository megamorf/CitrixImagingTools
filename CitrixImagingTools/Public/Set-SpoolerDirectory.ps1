Function Set-SpoolerDirectory
{
    <#
    .SYNOPSIS
        Sets the spooler directory to the specified location.

    .DESCRIPTION
        The redirection of the printer spooler directory is strongly recommended
        to prevent Windows from needlessly filling up the write cache on PVS target devices.

    .PARAMETER Path
        The printer spooler target location. Gets created if it doesn't exist.
        For PVS target devices the path should point to the write cache disk.

    .PARAMETER RestoreDefaultPath
        If used resets the spooler directory to its default path.

    .EXAMPLE
        Set-SpoolerDirectory -Path "$env:WriteCachePath\Spooler"

        Changes the printer spooler path to the specified location.

    .EXAMPLE
        Set-SpoolerDirectory -RestoreDefaultPath -Verbose

        Restores the printer spooler path to its default location.

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Filesystem, Build
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Default')]
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
        if ($PSCmdlet.ShouldProcess($Path, 'Create Spooler directory'))
        {
            New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop | Out-Null
        }

    }

    if ($PSCmdlet.ShouldProcess($Path, 'Set spooler directory'))
    {
        $SpoolerParams = @{
            Path  = 'HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers'
            Name  = 'DefaultSpoolDirectory'
            Value = $Path
        }

        Set-ItemProperty @SpoolerParams -ErrorAction Stop
    }

    if ((Get-Service -Name Spooler).Status -eq 'Running')
    {
        if ($PSCmdlet.ShouldProcess('Spooler', 'Restart service to apply settings'))
        {
            Restart-Service -Name Spooler -Force
        }
    }
}
