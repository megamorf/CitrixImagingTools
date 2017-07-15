Function Get-UniqueDiskID
{
    <#
    .SYNOPSIS
    Gets the unique disk ID of a specific drive.
    
    .DESCRIPTION
    Uses diskpart since PowerShell doesn't have access to the 
    unique disk ID property (Get-Disk returns a different ID).
    
    .PARAMETER DriveLetter
    The drive you want to get the unique disk ID from.
    
    .EXAMPLE
    Get-UniqueDiskID -DriveLetter G

    Driveletter DiskNumber UniqueDiskID
    ----------- ---------- ------------
    G                    2 A2EB1AE4
    
    .EXAMPLE
    Get-Partition -DriveLetter G | Get-UniqueDiskID

    Driveletter DiskNumber UniqueDiskID
    ----------- ---------- ------------
    G                    2 A2EB1AE4
    #>
    [CmdletBinding()]  
    param(
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 2)]
        [string]
        $DriveLetter = 'D'          
    )

    # Clean up drive letter in case the string contains a ':'
    [string]$DriveLetter = $DriveLetter[0]

    $DiskNumber = (Get-Partition -DriveLetter $DriveLetter -ErrorAction Stop).DiskNumber
    $DiskPartFile = "$env:temp\disksignature.txt"

    $OutFileParams = @{
        Encoding = 'Default'
        FilePath = $DiskPartFile
        WhatIf   = $false # Suppress unwanted WhatIf output
    }

    "select disk $DiskNumber" | Out-File @OutFileParams -Force
    "uniqueid disk" | Out-File @OutFileParams -Append
    $ResultRaw = Invoke-DiskpartScript -FilePath $DiskPartFile

    $SelectStringResult = $ResultRaw | Select-String -Pattern "ID:\s*(?<DiskID>[^\s]+)" -AllMatches
    $UniqueDiskID = $SelectStringResult.Matches.ForEach{$_.Groups['DiskID'].Value} | Select-Object -Unique

    [PSCustomObject]@{
        Driveletter  = $DriveLetter.ToUpper()
        DiskNumber   = $DiskNumber
        UniqueDiskID = $UniqueDiskID
    }
}
