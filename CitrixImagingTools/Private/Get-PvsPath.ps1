Function Get-PvsPath
{
    <#
    .SYNOPSIS
        Returns DirectoryInfo object of PVS Tools if found or exits with an error.

    .EXAMPLE
        Get-PvsPath
    #>
    try
    {
        if (Test-Path -LiteraPath "$env:ProgramFiles\Citrix\Provisioning Services")
        {
            $Path = Get-Item -LiteraPath "$env:ProgramFiles\Citrix\Provisioning Services"
        }
        else
        {
            $Pkg = Get-Package -Name 'Citrix Provisioning Services Target Device x64'
            $Path = Get-Item -LiteraPath $Pkg.FullPath
        }

        return $Path
    }
    catch
    {
        throw "PVS not found - aborting"
    }
}
