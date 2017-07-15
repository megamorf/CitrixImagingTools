Function Get-AutoAdminLogon
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [CmdletBinding()]
    param()

    $Path = 'HKLM:\Software\Microsoft\Windows NT\Currentversion\WinLogon'

    function Get-ItemPropertyValueSafe
    {
        param($Path, $Name)

        try
        {
            Get-ItemPropertyValue -Path $Path -Name $Name
        }
        catch
        {
            $null
        }
    }

    $Enabled = [bool](Get-ItemPropertyValueSafe -Path $Path -Name AutoAdminLogon)
    $Username = Get-ItemPropertyValueSafe -Path $Path -Name DefaultUserName
    $Password = Get-ItemPropertyValueSafe -Path $Path -Name DefaultPassword | ForEach-Object {
        if ($null -ne $_)
        {
            ConvertTo-SecureString -String $_ -AsPlainText -Force
        }
    }

    [PSCustomObject]@{
        Enabled  = $Enabled
        Username = $Username
        Password = $Password
    }
}
