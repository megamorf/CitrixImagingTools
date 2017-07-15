Function Get-WtsType
{
    try
    {
        if (Select-String -Path 'C:\Personality.ini' -Pattern ([regex]::Escape('$DiskName=')) -ErrorAction Stop)
        {
            return 'PVS'
        }
        else
        {
            return 'MCS'
        }
    }
    catch
    {
        throw 'C:\Personality.ini not found. Server is not provisioned via PVS/MCS.'
    }
}

