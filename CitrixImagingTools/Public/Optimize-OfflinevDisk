Function Optimize-OfflinevDisk
{
    <#
    .SYNOPSIS
        Optimizes the specified vDisk(s).

    .DESCRIPTION
        When you have created a new image or merged an image to a new base image in PVS it is best practice to
        defragment the vDisk (.VHD/.VHDX) file. Defragmenting the vDisk resulted in write cache savings of up to
        30% or more during testing.

        Defragmenting a versioned vDisk (.AVHD) is not recommended. If you defragment a versioned vDisk (.AVHD)
        you will end up with a large vDisk file.

        Note:
        The optimization is done by mounting the vDisk on the PVS server and running a defragmentation on it.
        This allows for a more robust defragmentation as the OS is not loaded. An additional 15% reduction in 
        the write cache size was seen with this approach over defragmentation in the running OS.

        The culprit above in excessive write cache size is fragmentation. This is caused because PVS redirection 
        is block based and not file based. The redirection to the write cache is based on the logical block level 
        structure of the vDisk.

    .PARAMETER PvsDisk
        One or more vDisks that should be optimized. Accepts the following objects:
        - Citrix.PVS.SnapIn.PvsDisk
        - Citrix.PVS.SnapIn.PvsDiskInfo

    .EXAMPLE
        Optimize-OfflinevDisk -PvsDisk $MyPvsDisk -Verbose

        Performs an offline optimization for $MyPvsDisk - this let's you go through the entire process step by step.

        $MyPvsDisk can be aquired like so:
        $MyPvsDisk = Get-PvsDisk -Name vDiskName -SiteName "Contoso" -StoreName "DS-Prod"

    .EXAMPLE
        Get-LatestvDisk | Optimize-OfflinevDisk -Verbose -Confirm:$false

        Performs an offline optimization for the latest vDisk but doesn't prompt for confirmation. Use -Confirm:$false
        to use the function non-interactively.

    .EXAMPLE
        $Disks | Optimize-OfflinevDisk -Verbose -Confirm:$false

        Performs an offline optimization for all inactive vDisks in the store "DS-Prod" but doesn't prompt for 
        confirmation.Use -Confirm:$false to use the function non-interactively.

        Store all disks from a specific store like this:
        $Disks = Get-DiskInfo -StoreName "DS-Prod" -SiteName "Contoso"

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Cleanup, Optimization, PVS
    #>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.PSObject.TypeNames[0] -in @('Citrix.PVS.SnapIn.PvsDisk', 'Citrix.PVS.SnapIn.PvsDiskInfo') })]
        [psobject[]] $PvsDisk
    )

    BEGIN
    {
        Test-PvsConnection
    }

    PROCESS
    {
        foreach ($vDisk in $PvsDisk)
        {
            #region pre-flight checks
            # Verify disk is not active
            $Info = $vDisk | Get-PvsDiskInfo -Verbose:$false
            if ($Info.Active)
            {
                Write-Warning -message "Disk $($Info.Name) is in use - cannot optimize active vDisk."
                continue
            }

            # If not active but locked, remove lock
            if ($Info.Locked)
            {
                if ($PSCmdlet.ShouldProcess($Info.Name, 'Remove lock'))
                {
                    $vDisk | Unlock-PvsDisk -ErrorAction Stop
                }
            }
            #endregion

            if ($PSCmdlet.ShouldProcess($vDisk.OriginalFile, 'Mount vDisk with 30sec timeout'))
            {
                $DriveLetter = $vDisk | Mount-PvsDisk -MaxDiskLetterWaitSeconds 30 -Verbose:$false

                if ([string]::IsNullOrEmpty($DriveLetter))
                {
                    Write-Warning -Message "Could not mount vDisk $($Info.Name)"
                    continue
                }

                Write-Verbose -Message ("Mounted disk as [$DriveLetter`:]" | Add-Prefix)
            }

            if ($PSCmdlet.ShouldProcess($vDisk.OriginalFile, 'Optimize vDisk'))
            {
                Optimize-Volume -DriveLetter $DriveLetter -Verbose
            }

            if ($PSCmdlet.ShouldProcess($vDisk.OriginalFile, 'Unmount vDisk'))
            {
                Dismount-PvsDisk -Verbose:$false
                Write-Verbose -Message ("Unmounted disk $($Info.Name)" | Add-Prefix)
            }

        } #end foreach loop
    }
}

