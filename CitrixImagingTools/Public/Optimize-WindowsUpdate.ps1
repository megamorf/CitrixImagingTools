function Optimize-WindowsUpdate
{
    if (
        ([System.Environment]::OSVersion.Version.Major -gt 6) -or
        ([System.Environment]::OSVersion.Version.Minor -ge 2)
    )
    {
        Dism.exe /Online /Cleanup-Image /StartComponentCleanup
        if ($LASTEXITCODE)
        {
            throw 'Dism.exe clean failed'
        }
    }
}
