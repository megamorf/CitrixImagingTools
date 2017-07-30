function Start-P2PVS
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    # Build Path
    $PVSPATH = (Get-PvsPath).FullName
    $TargetOptimizerTool = "$PVSPATH\TargetOSOptimizer.exe"
    $P2PVSTool = "$PVSPATH\P2PVS.exe"

    # Optimize image
    Write-Verbose -Message ("Starting $TargetOptimizerTool in silent mode to optimize master." | AddPrefix)
    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Run target optimizer tool'))
    {
        Start-Process -FilePath $TargetOptimizerTool -ArgumentList '/s' -Wait
    }

    # Start imaging
    Write-Verbose -Message ("Starting P2PVS image capture" | AddPrefix)
    Write-Verbose -Message ("If you see a Windows pop-up to format the disk, please click Cancel or do nothing" | AddPrefix)
    if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Start image capture'))
    {
        Start-Process -FilePath $P2PVSTool -ArgumentList 'P2PVS C: /AutoFit /L' -Wait -PassThru
    }
}
