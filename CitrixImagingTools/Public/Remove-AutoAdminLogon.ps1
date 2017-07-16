Function Remove-AutoAdminLogon
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess("Username=$Username,Domain=$Domain", 'Remove AutoAdminLogon'))
    {

    }
}
