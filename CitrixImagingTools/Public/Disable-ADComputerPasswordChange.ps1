function Disable-ADComputerPasswordChange
{
    $Params = @{
        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters'
        Name         = 'DisablePasswordChange'
        PropertyType = 'Dword'
        Value        = 1
    }
    
    New-ItemProperty @Params -Force
}