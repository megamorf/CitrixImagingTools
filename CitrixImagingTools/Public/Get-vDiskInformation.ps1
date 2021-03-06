Function Get-vDiskInformation
{
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param()

    $vDisk = [pscustomobject]@{
        Computername               = $env:COMPUTERNAME
        isValidTargetDevice        = (Test-Path -Path 'HKLM:System\CurrentControlSet\Services\bnistack\pvsagent')
        WriteCacheTypeID           = $null
        WriteCacheType             = $null
        WriteCacheDrive            = $null
        WriteCacheFile             = $null
        WriteCacheSizeMB           = $null
        WriteCacheDriveFreePercent = $null
        vDiskSizeGB                = $null
        vDiskName                  = $null
        vDiskType                  = $null
    }

    if ($vDisk.isValidTargetDevice)
    {

        $content = Get-Personality
        $vDisk.WriteCacheTypeID = $content["StringData"]["`$WriteCacheType"]
        $vDisk.WriteCacheDrive = (Get-ItemProperty HKLM:System\CurrentControlSet\Services\bnistack\pvsagent).WriteCacheDrive

        # Percent Free Disk space (is the cache drive in danger of being full?)
        $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$($vDisk.WriteCacheDrive)'"
        $vDisk.WriteCacheDriveFreePercent = [System.Math]::Round($Disk.FreeSpace / $Disk.Size * 100, 1)

        If ($vDisk.WriteCacheTypeID -eq "4")
        {
            $vDisk.WriteCacheType = "CacheOnHarddrive"

            # Cache on hard drive only
            $vDisk.WriteCacheFile = Join-Path $vDisk.WriteCacheDrive '\.vdiskcache'

            # CacheDiskOverflowSize
            $vDisk.WriteCacheSizeMB = [Math]::Round((Get-Item $vDisk.WriteCacheFile -Force).length / 1MB)
        }
        ElseIf ($vDisk.WriteCacheTypeID -eq "9")
        {
            $vDisk.WriteCacheType = "RAMCacheWithDiskOverflow"

            # RAM Cache with disk overflow
            $vDisk.WriteCacheFile = Join-Path $vDisk.WriteCacheDrive '\vdiskdif.vhdx'

            # CacheDiskOverflowSize
            $vDisk.WriteCacheSizeMB = [Math]::Round((Get-Item $vDisk.WriteCacheFile -Force).length / 1MB)

            # NonPaged Pool Memory (RAM Cache in use) adjusted for likely kernel usage
            $vDisk | Add-Member -MemberType NoteProperty -Name RamCacheUsageMB -Value ([math]::Round((Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Memory).PoolNonPagedBytes / 1MB))

        }
        Else
        {
            $vDisk.WriteCacheType = 'Unsupported'
        }
    }

    if (Test-Path -LiteralPath 'C:\Personality.ini')
    {
        $Personality = Get-Personality

        $vDisk.vDiskName = $Personality['StringData'].'$DiskName'
        $vDisk.vDiskType = $vDisk.vDiskName.ToUpper().split('.')[-1]

        $OSDrive = Get-PSDrive -Name ($env:SystemDrive)[0]
        $vDisk.vDiskSizeGB = ($OSDrive.Used + $OSDrive.Free) / 1GB
    }

    $vdisk
}
