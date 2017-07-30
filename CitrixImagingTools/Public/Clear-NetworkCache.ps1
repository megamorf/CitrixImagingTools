function Clear-NetworkCache
{
    <#
    .SYNOPSIS
        Clears DNS and ARP cache

    .DESCRIPTION
        Clears DNS and ARP cache using ipconfig and arp.

    .EXAMPLE
        Clear-NetworkCache

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Network, Sealing
    #>

    ipconfig.exe /flushdns
    arp.exe -d
}
