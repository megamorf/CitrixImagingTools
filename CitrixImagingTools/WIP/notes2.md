<#

From Citrix Discussions: what happens is if the name cannot be retrieved from the bootstrap then the name defaults to the mac address.  You can force the target to ask again for the target’s machine name by setting the following registry key in the registry.

HKLM\System\CurrentControlSet\services\bnistack\Parameters  (you may have to create the Parameters key if it is not already created)
EnableGetComputerName DWORD 1  (default is 0 or disabled)
#>


<#
HKEY_LOCAL_MACHINE\SOFTWARE\VMware, Inc.\VMware Tools

disable pvs icon in systray
HKLM\Software\Citrix\ProvisioningServices\StatusTray

“ShowIcon” (DWORD) = 0

This however will disable to all users, even Admins, and I wanted to be able give administrators the option to see the icon.

Solution: Apply the HKCU key below to your profile solution based on Group membership (Group Policy Preferences > Item Level Targeting):

Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Citrix\ProvisioningServices\StatusTray]

“ShowIcon”=dword:00000000
Once that is in place the icon will go away.

#>

