#region Disable Windows Autoupdate
$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'
If (-not (Test-Path $Path))
{
    New-ItemProperty -Path $Path -Name AUOptions -Value 1 -PropertyType Dword
    New-ItemProperty -Path $Path -Name ScheduledInstallDay -Value 0 -PropertyType Dword
    New-ItemProperty -Path $Path -Name ScheduledInstallTime -Value 3 -PropertyType Dword
}

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv' -Name Start -Value 4
#endregion

#region Disable Offline Files
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache' -Name Enabled -Value 0
#endregion

#region Disable Disk Defragmentation BootOptimizeFunction
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction' -Name Enable -Value 'N'
#endregion

#region Disable Background Layout Service
Set-ItemProperty -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout' -Name EnableAutoLayout -Value 0 #dword
#endregion

#region Last Access Time Stamp
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name
#endregion

#region Reduce DedicatedDumpFile DumpFileSize to 2MB
Set-ItemProperty -Path  -Name DumpFileSize -Value 2 #dword
Set-ItemProperty -Path  -Name IgnorePagefileSize -Value 1 #dword
#endregion

#region Move to Recycle Bin
Set-ItemProperty -Path  -Name NoRecycleFiles -Value 1 #dword
#endregion

#region Disable Clear Page File at Shutdown
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name ClearPageFileAtShutdown -Value 0 #dword
#endregion

#region Disable Machine Account Password Changes
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' -Name DisablePasswordChange -Value 1 #dword
#endregion

#region Increase Service Startup Timeout
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name ServicesPipeTimeout -Value #dword:0002bf20
#endregion

#region 
Set-ItemProperty -Path  -Name  -Value 
#endregion

#region 
Set-ItemProperty -Path  -Name  -Value 
#endregion

#region 
Set-ItemProperty -Path  -Name  -Value 
#endregion

#region 
Set-ItemProperty -Path  -Name  -Value 
#endregion

#region 
Set-ItemProperty -Path  -Name  -Value 
#endregion

#region 
Set-ItemProperty -Path  -Name  -Value 
#endregion

#region 
Set-ItemProperty -Path  -Name  -Value 
#endregion

#####

#region Disable Large Send Offload
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\BNNS\Parameters' -Name EnableOffload -Value 0 #dword
#endregion

#region Disable TCP/IP Offload
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name DisableTaskOffload -Value 1 #dword
#endregion

