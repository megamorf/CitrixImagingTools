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
        ToDo: Add tags, author info
    #>

    ipconfig.exe /flushdns
    arp.exe -d
}
