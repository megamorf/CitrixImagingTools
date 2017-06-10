Function Initialize-TargetDeviceWriteCache
{
    <#
    .SYNOPSIS
        Sets up a target device write cache disk
    .DESCRIPTION
        To ensure that the new system will be consistent with the drive letter assignment, you must change the unique id
        for the write cache disk to match the master target device disk.
    .PARAMETER DriveLetter
        The drive letter under which the write cache disk is mounted.
    .PARAMETER DriveLabel
        The expected label of the write cache disk.
    .PARAMETER MasterUniqueDiskID
        The unique disk ID of the write cache disk that was attached to your
        golden image master at build time.
    .EXAMPLE
        Initialize-TargetDeviceWriteCache
        
        Applies the default configuration:
        - Drive Letter:   D
        - Drive Label:    WriteCache
        - Unique Disk ID: f000000f
    .NOTES
        Work in Progress
    .LINK
        https://support.citrix.com/article/CTX133476
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1,2)]
        [string]
        $DriveLetter = 'D',   

        [ValidateNotNullOrEmpty()]
        [ValidateLength(0,32)]
        [string]
        $DriveLabel = 'WriteCache',

        [ValidateNotNullOrEmpty()]
        [string]
        $MasterUniqueDiskID
    )

    # Clean up drive letter in case the string contains a ':'
    [string]$DriveLetter = $DriveLetter[0]
    
    #region Pre-Flight checks
    # Check if we're even dealing with PVS
    $TargetDeviceInfo = Get-vDiskInformation

    if(-not $TargetDeviceInfo.IsValidTargetDevice)
    {
        throw 'Please install target device drivers first. Aborting...'
    }
    
    if(Get-PSDrive -Name $DriveLetter -PSProvider FileSystem)
    {
        throw "Drive letter $DriveLetter is currently in use. Please remap the blocking device or choose a different drive letter. Aborting..." 
    }
    
    # Get All Disks and detect vDisks and regular Disks
    $DiskDrives = Get-CimInstance Win32_DiskDrive -Filter "MediaType = 'Fixed hard disk media'"
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
            Write-Warning -Message 'No Harddisk found for Write Cache!';
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

    $WriteCacheVolume = $WriteCacheDisk | Get-Partition | Get-Volume
    #endregion

    if($TargetDeviceInfo.vDiskMode -eq 'Shared')
    {
        Write-Verbose -Message '[+] Setting up Write Cache Partition'
        Get-Disk | Where-Object PartitionStyle -eq 'raw' -| Initialize-Disk -PartitionStyle MBR

        $IsNtfsFormatted = $WriteCacheVolume.FileSystem -eq 'NTFS'

        if($IsNtfsFormatted)
        {
            if($WriteCacheVolume.FileSystemLabel -ne $DriveLabel)
            {
                Write-Verbose -Message '  Write Cache Partition is already formatted but the label is wrong'
                Write-Verbose -Message "  Label = $DriveLabel"
                $WriteCacheVolume | Set-Volume -NewFileSystemLabel $DriveLabel
            }

            if($WriteCacheVolume.DriveLetter -ne $DriveLetter)
            {
                Write-Verbose -Message '  Write Cache Partition is already formatted but the drive letter is wrong'
                Write-Verbose -Message "  Drive = $DriveLetter"
                $WriteCacheDisk | Get-Partition | Set-Partition -NewDriveLetter $DriveLetter
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
            Set-UniqueDiskId -ID $MasterUniqueDiskID -DriveLetter $DriveLetter
        }
        else
        {
            Write-Verbose "  Using default ID: 'f000000f'"
            Set-UniqueDiskId -ID 'f000000f' -DriveLetter $DriveLetter
        }   
    }
}
