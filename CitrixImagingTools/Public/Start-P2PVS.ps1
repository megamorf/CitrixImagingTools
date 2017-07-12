function Start-P2PVS 
{    
    [CmdletBinding()]
    param()
    
    # Build Path
    $PVSPATH = (Get-PvsPath).FullPath
    $TargetOptimizerTool = "$PVSPATH\TargetOSOptimizer.exe"
    $P2PVSTool = "$PVSPATH\P2PVS.exe"

    # Optimize image
    Write-Host "Starting $TargetOptimizerTool in silent mode to optimize master." 
    Start-Process -FilePath $TargetOptimizerTool -ArgumentList '/s' -Wait

    # Start imaging
    Write-Host "Starting P2PVS"
    Write-Host "If you see a Windows pop-up to format the disk, please click Cancel or do nothing"
    Start-Process -FilePath $P2PVSTool -ArgumentList 'P2PVS C: /AutoFit /L'
}
