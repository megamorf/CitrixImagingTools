function Get-OSInfo
{
    $ComputerSystemInfo = Get-CimInstance -ClassName win32_computersystem -Property DNSHostName, Domain, NumberOfLogicalProcessors, NumberOfProcessors, PartOfDomain
    $DriveInfo = Get-CimInstance -ClassName Win32_LogicalDisk
    $NICInfo = Get-CimInstance -ClassName win32_networkadapterconfiguration -Filter "DHCPEnabled='True' and DNSHostName='$env:COMPUTERNAME'"

    [pscustomobject]@{
        PSVersion = $PSVersionTable.PSVersion
        Domain = $ComputerSystemInfo.Domain
        PartOfDomain = $ComputerSystemInfo.PartOfDomain
        Drives = [pscustomobject]@{
            Disks = $DriveInfo | Where-Object DriveType -eq 3
            CD = $DriveInfo | Where-Object DriveType -eq 5
            Floppy = $DriveInfo | Where-Object DriveType -eq 2
        }
        NICs = $NICInfo
    }

}
