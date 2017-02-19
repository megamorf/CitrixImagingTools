Function Get-PvsPath
{
    If (Get-Command -Name Get-Package -Module PackageManagement -CommandType Cmdlet)
    {
        $Pkg = Get-Package -Name 'Citrix Provisioning Services Target Device x64'
        $Path = Get-Item -LiteraPath $Pkg.FullPath
    }
    elseif (Test-Path -LiteraPath "$env:ProgramFiles\Citrix\Provisioning Services")
    {
        $Path = Get-Item -LiteraPath "$env:ProgramFiles\Citrix\Provisioning Services"
    }
    else 
    {
        throw "PVS not found - aborting"
    }

    return $Path
}
