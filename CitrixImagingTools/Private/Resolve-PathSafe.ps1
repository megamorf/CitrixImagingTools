function Resolve-PathSafe
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [string[]] $Path
    )
    foreach($P in $Path)
    {
        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($P)
    }
}
