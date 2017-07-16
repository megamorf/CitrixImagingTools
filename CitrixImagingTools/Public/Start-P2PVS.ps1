function Start-P2PVS
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param()

    # Build Path
    $PVSPATH = (Get-PvsPath).FullPath
    $TargetOptimizerTool = "$PVSPATH\TargetOSOptimizer.exe"
    $P2PVSTool = "$PVSPATH\P2PVS.exe"

    # Optimize image
    Write-Verbose -Message ("Starting $TargetOptimizerTool in silent mode to optimize master." | AddPrefix)
    Start-Process -FilePath $TargetOptimizerTool -ArgumentList '/s' -Wait

    # Start imaging
    Write-Verbose -Message ("Starting P2PVS" | AddPrefix)
    Write-Verbose -Message ("If you see a Windows pop-up to format the disk, please click Cancel or do nothing" | AddPrefix)
    Start-Process -FilePath $P2PVSTool -ArgumentList 'P2PVS C: /AutoFit /L' -Wait -PassThru
}
