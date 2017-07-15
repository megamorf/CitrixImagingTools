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

    if ($pscmdlet.ShouldProcess($Status)) 
    {
        Write-Verbose -Message "$Logmsg - a reboot is required to apply the changes."
        New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system' -Name EnableLUA -PropertyType DWord -Value $Value -Force
    }
}