function Register-PvsSnapin
{
    $installutil = "$env:systemroot\Microsoft.NET\Framework\v4.0.30319\installutil.exe"
    $installutil64 = "$env:systemroot\Microsoft.NET\Framework64\v4.0.30319\installutil.exe"

    Write-Verbose -Message ('Unregister old Snapin' | AddPrefix)
    & $installutil -u "$env:ProgramFiles\Citrix\Provisioning Services Console\McliPSSnapIn.dll"
    & $installutil64 -u "$env:ProgramFiles\Citrix\Provisioning Services Console\McliPSSnapIn.dll"

    Write-Verbose -Message ('Register new Snapin' | AddPrefix)
    & $installutil "$env:ProgramFiles\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll"
    & $installutil64 "$env:ProgramFiles\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll"
}
