filter AddPrefix
{
    "$(Get-Date -Format "yyyyMMdd HH:mm:ss.ffff") [$((Get-PSCallStack)[1].Command)]: $_"
}