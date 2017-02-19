Function Get-XenConvertPath
{
    If (Get-Command -Name Get-Package -Module PackageManagement -CommandType Cmdlet)
    {
        $Pkg = Get-Package -Name 'Citrix XenConvert_x64'
        $Path = Get-Item -LiteraPath $Pkg.FullPath
    }
    elseif (Test-Path -LiteraPath "$env:ProgramFiles\Citrix\XenConvert")
    {
        $Path = Get-Item -LiteraPath "$env:ProgramFiles\Citrix\XenConvert"
    }
    else 
    {
        throw "XenConvert not found - aborting"
    }

    return $Path
}
