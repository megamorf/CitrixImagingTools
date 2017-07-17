function Set-UACStatus
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        $Status
    )

    switch ($Status)
    {
        'Enabled'
        {
            $Logmsg = 'Enabling UAC'
            $Value = 1
        }
        'Disabled'
        {
            $Logmsg = 'Disabling UAC'
            $Value = 0
        }
    }

    if ($PSCmdlet.ShouldProcess($Status))
    {
        Write-Verbose -Message ("$Logmsg - a reboot is required to apply the changes." | AddPrefix)
        $Params = @{
            Path         = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system'
            Name         = 'EnableLUA'
            PropertyType = 'DWord'
            Value        = $Value
        }
        New-ItemProperty @Params -Force | Out-Null
    }
}
