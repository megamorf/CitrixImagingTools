function Disable-ADComputerPasswordChange
{
    <#
    .SYNOPSIS
        Disables periodic AD computer password changes.

    .DESCRIPTION
        This is required for PVS target devices since. PVS takes
        care of changing the passwords in AD every 7 days by default.

    .EXAMPLE
        Disable-ADComputerPasswordChange

        ToDO: Add examples
    .NOTES
        ToDo: Add tags, author info
    #>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param()

    $Params = @{
        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters'
        Name         = 'DisablePasswordChange'
        PropertyType = 'Dword'
        Value        = 1
    }

    if ($PSCmdlet.ShouldProcess('Disable periodic Computer password changes'))
    {
        New-ItemProperty @Params -Force
    }
}
