function Clear-NetworkCache
{
    ipconfig.exe /flushdns
    arp.exe -d
}