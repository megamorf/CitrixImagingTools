function Optimize-GlobalAssemblyCache
{
    <#
    .SYNOPSIS
        Optimizes the global assembly cache by executing queued assembly compilation
        jobs.

    .DESCRIPTION
        Prevents mscorsvw.exe from needlessly creating high CPU load due to compiling
        .NET assemblies in the background during idle time. This command forces all
        queued compilation jobs to be executed in order to update the global assembly
        cache.

    .EXAMPLE
        Optimize-GlobalAssemblyCache -Verbose

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Process, Sealing
    #>

    [CmdletBinding()]
    param()

    $NgenPath = Get-ChildItem -Path "$env:windir\Microsoft.NET" -Recurse -Filter 'ngen.exe'

    foreach ($ngenExe in $NgenPath.FullName)
    {
        Write-Verbose -Message ("Precompiling assemblies with [$ngenExe]" | AddPrefix)
        Start-Process $ngenExe -ArgumentList 'executeQueuedItems' -Wait
    }
}
