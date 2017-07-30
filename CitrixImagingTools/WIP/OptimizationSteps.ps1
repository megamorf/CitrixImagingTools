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
at HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Network to 1 to affect all users of the computer.


#endregion

#region disable memory dump creation
#[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl]
“CrashDumpEnabled”=dword:00000000
“LogEvent”=dword:00000000
“SendAlert”=dword:00000000
#endregion



#region Increase Service Startup Timeout
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name ServicesPipeTimeout -Value #dword:0002bf20
#endregion


# services server 2016
# https://blogs.technet.microsoft.com/secguide/2017/05/29/guidance-on-disabling-system-services-on-windows-server-2016-with-desktop-experience/

# disable indexing service
# Before switching vDisk to Standard Image mode: “ipconfig/release” (release DHCP address).

<#
Alignment issues
Constructed with extra byte at end of file
Dynamic VHD always misaligns disk with storage
Use only fixed-size VHDs for write-cache drives and Provisioning services vDisks.
#>
