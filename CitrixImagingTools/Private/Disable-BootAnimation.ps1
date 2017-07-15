Function Disable-BootAnimation
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param()

    if($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Disable boot animation'))
    {
        bcdedit /set bootux disabled
    }
}
