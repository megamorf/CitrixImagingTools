Function Initialize-TargetDeviceWriteCache
{
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        To ensure that the new system will be consistent with the drive letter assignment, you must change the unique id
        for the write cache disk to match the master target device disk.
    .PARAMETER DriveLetter

    .PARAMETER DriveLabel

    .PARAMETER MasterUniqueDiskID

    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    .LINK
        https://support.citrix.com/article/CTX133476
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1,2)]
        [string]
        $DriveLetter = 'D',

        [ValidateNotNullOrEmpty()]
        [string]
        $DriveLabel = 'WriteCache',

        [ValidateNotNullOrEmpty()]
        [string]
        $MasterUniqueDiskID
    )

    # Clean up drive letter in case the string contains a ':'
    $DriveLetter = $DriveLetter[0]
    
    # Check if we're even dealing with PVS
    $TargetDeviceInfo = Get-vDiskInformation

    if(-not $TargetDeviceInfo.IsValidTargetDevice)
    {
        throw 'Please install target device drivers first'
    }
    
    #region Pre-Flight checks
    # Get All Disks and detect vDisks and regular Disks
    $DiskDrives = Get-CimInstance Win32_DiskDrive #type=3
    $vDisks,$Harddisks = $DiskDrives.Where({$_.Caption -like 'Citrix Virtual*'}, 'Split')    

    # We'll see what we can do with this
    # not used atm
    if($vDisks.Count -eq 1)
    {
        $vDiskFound = $true
    }
    else
    {
        $vDiskFound = $false
    }

    switch ($Harddisks.Count)
    {
        0 { 
            Write-Warning -Message 'No HardDisk found for Write Cache!';
            Write-Warning -Message 'Please add a disk and re-run the command. Aborting...' continue
        }
        1 {  
            Write-Verbose 'Harddisk for Write Cache found'
            $WriteCacheDisk = $Harddisks
            break
        }
        default { 
            Write-Verbose -Message 'More than 1 Harddisk found, selecting first one' 
            $WriteCacheDisk = $Harddisks[0]
        }
    }

    $WriteCachePartition = $WriteCacheDisk | Get-Partition | Get-Volume
    #endregion

    if($TargetDeviceInfo.vDiskMode -eq 'Shared')
    {
        Write-Verbose -Message '[+] Setting up Write Cache Partition'
        Get-Disk | Where-Object PartitionStyle -eq 'raw' -| Initialize-Disk -PartitionStyle MBR

        $IsNtfsPartitioned = $WriteCachePartition.FileSystem -eq 'NTFS'

        if($IsNtfsPartitioned)
        {
            if($WriteCachePartition.FileSystemLabel -ne $DriveLabel)
            {
                Write-Verbose -Message '  Write Cache Partition is already formatted but the label is wrong'
                Write-Verbose -Message "  Label = $DriveLabel"
                $WriteCachePartition | Set-Volume -NewFileSystemLabel $DriveLabel
            }

            if($WriteCachePartition.DriveLetter -ne $DriveLetter)
            {
                Write-Verbose -Message '  Write Cache Partition is already formatted but the drive letter is wrong'
                Write-Verbose -Message "  Drive = $DriveLetter"
                $WriteCacheDisk | Get-Partition | Set-Partition -NewDriveLetter
            }
        }
        else
        {
            Write-Verbose -Message '  Write Cache is not formatted.'
            Write-Verbose -Message "  Drive = $DriveLetter"
            Write-Verbose -Message "  Label = $DriveLabel"
            $NewPartition = $WriteCacheDisk | New-Partition -UseMaximumSize -DriveLetter $DriveLetter
            $NewPartition | Format-Volume -FileSystem NTFS -NewFileSystemLabel $DriveLabel
        }
        
        Write-Verbose '[+] Fixing Write Cache MBR Unique Disk ID mismatch'
        if($MasterUniqueDiskID)
        {
            Write-Verbose "  Using custom ID: '$MasterUniqueDiskID'"
            $WriteCacheDisk | Set-DiskUniqueId $MasterUniqueDiskID
        }
        else
        {
            Write-Verbose "  Using default ID: 'f000000f'"
            $WriteCacheDisk | Set-DiskUniqueId
        }   
    }
}