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



#region Increase Service Startup Timeout
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name ServicesPipeTimeout -Value #dword:0002bf20
#endregion
