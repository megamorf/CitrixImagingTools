function Disable-Service
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [string[]]
        $Exclude
    )

    switch (Get-OperatingSystemFamily)
    {
        'Windows Server 2016' {$file = "$PSScriptRoot\Services-2016.csv" ; break}
        'Windows Server 2012 R2' {$file = "$PSScriptRoot\Services-2012r2.csv" ; break}
        'Windows Server 2012' {$file = "$PSScriptRoot\Services-2012.csv" ; break}
        'Windows 10' {$file = "$PSScriptRoot\Services-Win10.csv" ; break}
        'Windows 8.1' {$file = "$PSScriptRoot\Services-Win81.csv" ; break}
        default {Write-Warning -Message "No supported OS found"; return}
    }

    $ServicesToDisable = Import-Csv -Path $file -Delimiter ';'
    $CsvHeaderFields = ($ServicesToDisable | Get-Member -MemberType NoteProperty).Name
    @('ServiceName', 'ServiceDescription', 'Notes').ForEach( {
            if ($_ -notin $CsvHeaderFields)
            {
                throw "Error importing service list - field [$_] not found"
            }
        })

    Write-Verbose -Message ('[+] Start disabling services' | AddPrefix)

    foreach ($Service in $ServicesToDisable)
    {
        if ($Service.ServiceName -in $Exclude)
        {
            Write-Verbose -Message ("`tSkipping excluded service: $($Service.ServiceName)" | AddPrefix)
            continue
        }
        else
        {
            Write-Verbose -Message ("`tDisabling service: $($Service.ServiceName)" | AddPrefix)
            try
            {
                Stop-Service -Name $Service.ServiceName -Force -PassThru | Set-Service -StartupType Disabled
            }
            catch
            {
                # If a service cannot be found the FullyQualifiedErrorId is:
                # NoServiceFoundForGivenName,Microsoft.PowerShell.Commands.StopServiceCommand
                Write-Verbose -Message ("`t" + $_.Exception.Message | AddPrefix)
            }
        }
    }

    Write-Verbose -Message ('[+] End disabling services' | AddPrefix)
}
