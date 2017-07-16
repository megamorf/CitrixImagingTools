function Set-UniqueDiskID
{
    <#
    .SYNOPSIS
        Changes the unique disk ID of a harddrive

    .DESCRIPTION
        Uses diskpart since PowerShell doesn't have access to the
        unique disk ID property (Get-Disk returns a different ID).

    .PARAMETER ID
        New unique disk ID. Can be:
        - MBR: 8 character hex string
        - GPT: GUID

    .PARAMETER DriveLetter
        The drive you want to change the unique disk ID for.

    .EXAMPLE
        Set-UniqueDiskID -ID "A2EB1AE4" -DriveLetter G -OutVariable Result

        Driveletter  : G
        DiskNumber   : 2
        UniqueDiskID : A2EB1AE4
        OldID        : A2EB1AE5
        Result       : Success

    .EXAMPLE
        Set-UniqueDiskID -ID "A2EB1AE4" -DriveLetter G -OutVariable Result -WhatIf

        WhatIf: Performing operation "Change ID from A2EB1AE4 to A2EB1AE5" on Target "g: (Disk Number 2)".


        Driveletter  : G
        DiskNumber   : 2
        UniqueDiskID : A2EB1AE4
        OldID        : A2EB1AE4
        Result       : Unchanged

    .NOTES
        ToDo: add tags, author info.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [ValidateNotNullOrEmpty()]
        [Alias('UniqueDiskID')]
        $ID,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 2)]
        [string]
        $DriveLetter = 'D'
    )

    # Clean up drive letter in case the string contains a ':'
    [string]$DriveLetter = $DriveLetter[0]

    # Pre-Flight Checks
    if (-not ($ID -match '^([A-Fa-f0-9]{8})$' -or $ID -as [guid]))
    {
        throw "Invalid Disk ID provided [$ID]. Aborting..."
    }

    if ($DriveLetter -notmatch '[a-z]')
    {
        throw "Invalid Drive Letter provided [$DriveLetter]. Aborting..."
    }

    # Store previous state for comparison
    $Old = Get-UniqueDiskID -DriveLetter $DriveLetter

    $DiskNumber = (Get-Partition -DriveLetter $DriveLetter).DiskNumber
    $DiskPartFile = "$env:temp\disksignature.txt"
    $OutFileParams = @{
        Encoding = 'Default'
        FilePath = $DiskPartFile
        WhatIf   = $false # Suppress unwanted WhatIf output
    }

    "select disk $DiskNumber" | Out-File @OutFileParams -Force
    "uniqueid disk ID=$ID" | Out-File @OutFileParams -Append

    if ($PSCmdlet.ShouldProcess("$DriveLetter`: (Disk Number $DiskNumber)", "Change ID from $($Old.UniqueDiskID) to $ID"))
    {
        $null = Invoke-DiskpartScript -FilePath $DiskpartFile
    }

    # Get new state for comparison
    $New = Get-UniqueDiskID -DriveLetter $DriveLetter
    if ($Old.UniqueDiskID -eq $New.UniqueDiskID)
    {
        $Result = 'Unchanged'
    }
    else
    {
        $Result = 'Success'
    }

    $New | Add-Member -NotePropertyName OldID  -NotePropertyValue $Old.UniqueDiskID
    $New | Add-Member -NotePropertyName Result -NotePropertyValue $Result
    $New
}
