Disabling Automatic Disk Defragmentation prevents Windows XP from filling the vDisk write cache by automatically de-fragmenting the vDisk during boot time.

To disable automatic disk defragmentation, set the following registry key value data:

Key HKEY_LOCAL_MACHINE\Microsoft\Dfrg\BootOptimizeFunction

Value Name Enable

Value Type REG_SZ

Value Data N



####


f you have the Windows Automatic Updates service running on your target device, Windows periodically checks a Microsoft Web site and looks for security patches and system updates. If it finds updates that have not been installed, it attempts to download them and install them automatically. Normally, this is a useful feature for keeping your system up-to-date. However, in a Provisioning Services implementation using Standard Image mode, this feature can decrease performance, or even cause more severe problems. This is because the Windows Automatic Updates service downloads programs that fill the write cache. When using the target device’s RAM cache, filling the write cache can cause your target devices to stop responding.

Re-booting the target device clears both the target device and Provisioning Services write cache. Doing this after an auto-update means that the Automatic Updates changes are lost, which defeats the purpose of running Automatic Updates. (To make Windows updates permanent, you must apply them to a vDisk while it is in Private Image mode).

To prevent filling your write cache, make sure to disable the Windows Automatic Updates service for the target device used to build the vDisk.

###