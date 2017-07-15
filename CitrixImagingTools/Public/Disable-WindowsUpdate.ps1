function Disable-WindowsUpdate
{
    $Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'

    New-ItemProperty -Force -Path $Path -PropertyType Dword -Name AUOptions -Value 1
    New-ItemProperty -Force -Path $Path -PropertyType Dword -Name ScheduledInstallDay -Value 0
    New-ItemProperty -Force -Path $Path -PropertyType Dword -Name ScheduledInstallTime -Value 3

    Stop-Service -Name wuauserv -PassThru | Set-Service -StartupType Disabled
}
