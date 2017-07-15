function Start-SealImage
{
    
    if ($PSCmdlet.ShouldProcess($env:ComputerName, 'Clear Event Logs'))
    {
        Get-EventLog -List | % { $_.clear() }
        # wevtutil cl system
    }

    # If MS Distributed Transaction Service is installed, run msdtc.exe -reset

    # if MS Message Queuing is installed, clear its cache
    Get-Service -Name MQAC, MSMQ | Stop-Service 

    # Delete local profiles that are not required

    # Stop Citrix Profile Manager service
    Stop-Service ctxProfile -Force

    # If Citrix Profile Manager is configured via GPO, check that its INI in C:\Program Files\Citrix\User Profile Manager has been renamed
    Rename-Item "C:\Program Files\Citrix\User Profile Manager\UPMPolicyDefaults_all.ini" UPMPolicyDefaults_all.old -ErrorAction SilentlyContinue

    # Delete Citrix Profile Manager logs from c:\Windows\System32\LogFiles\User Profile Manager if not redirected to the cache disk
    Get-Item -Path C:\Windows\System32\LogFiles\UserProfileManager\* | Remove-Item -Force -Confirm:$False -ErrorAction SilentlyContinue


    # Start-DepersonalizeAntivirus
    # Start-DepersonalizeProfileManagement
    # Start-DepersonalizeMonitoringClient

    <#
    sccm
    System Centre Endpoint Protection
REM // Resets AntiMalware's scan state to that of a computer that has just completed a full scan, this prevents the creation of the MpIdleTask task
reg add "HKLM\SOFTWARE\Microsoft\Microsoft Antimalware\Scan" /v SFCState /t REG_DWORD /d 7 /f

REM // Removes the MpIdleTask scheduled task if it had already been created prior to the scan state key being set
schtasks /Delete /TN "\Microsoft\Microsoft Antimalware\MpIdleTask" /f

System Centre Configuration Manager
REM // Delete the Hardware Inventory cache 
WMIC /namespace:\\root\ccm\invagt path inventoryActionStatus where InventoryActionID="{00000000-0000-0000-0000-000000000001}" DELETE /NOINTERACTIVE

REM // Empty CcmCache (subfolders only)
for /f "delims=*" %%g in ('dir /ad /b C:\Windows\CCMCache') do rd /s/q "C:\Windows\CCMCache\%%g"

REM // Delete unique SCCM machine IDs and Certiticates
net stop CcmExec
if exist "C:\Windows\SMSCFG.INI" del /q "C:\Windows\SMSCFG.INI"
reg delete HKLM\SOFTWARE\Microsoft\SystemCertificates\SMS\Certificates\ /f
del /q "C:\Windows\ccm\logs\*.log"
#>

<#
we clear the key and initiate a successful RDP connection to pull a recent license.

reg delete HKLM\Software\Microsoft\MSLicensing\Store\LICENSE000 /f
mstsc /v someserver

Powershell to stop the SCCM service and remove the client certificate (this assumes you've already followed best-practice to put the smscfg.ini etc on the cache drive).

Write-Warning "Stopping SCCM and removing certificates"
net stop ccmexec
gci Cert:\LocalMachine\SMS | remove-item
write-Output "SMS certificates removed"
#>

}

<#
https://www.citrix.com/blogs/2015/01/19/size-matters-pvs-ram-cache-overflow-sizing/
"Defragment the vDisk before deploying the image and after major changes. Defragmenting the vDisk resulted in write cache savings of up to 30% or more during testing. This will impact any of you who use versioning as defragmenting a versioned vDisk is not recommended. Defragmenting a versioned vDisk will create excessively large versioned disks (.AVHD files). Run defragmentation after merging the vDisk versions.Note: Defragment the vDisk by mounting the .VHD on the PVS server and running a manual defragmentation on it. This allows for a more robust defragmentation as the OS is not loaded. An additional 15% reduction in the write cache size was seen with this approach over standard defragmentation."
#>


<#
Write-warning "Removing Google Chrome pecularities"
reg delete 'HKLM\SOFTWARE\Wow6432Node\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}' /f
reg delete 'HKLM\SOFTWARE\Wow6432Node\Google\Update\Clients\{8A69D345-D564-463c-AFF1-A69D9E530F96}' /f
reg delete 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}' /f
Write-Warning "Setting Chrome update services to disabled"
c:\windows\system32\sc config gupdatem start= disabled
c:\windows\system32\sc config gupdate start= disabled
#>

<#
# Clear cached DHCP settings to prevent BSOD
stop-service dhcp

Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters]
“NameServer”=””

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces]

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{GUID_OF_NETWORK_ADAPTOR}]
“NameServer”=””
“Domain”=””
“DhcpIPAddress”=””
“DhcpSubnetMask”=””
“DhcpServer”=””
“DhcpNameServer”=””
“DhcpDefaultGateway”=””
#>