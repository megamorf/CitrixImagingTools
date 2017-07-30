function Get-PVSRamCache
{
    <#
.Synopsis
   Query the current PVS RAM Cache size - Based on looking at the Pool Non Paged Memory
.DESCRIPTION
   Get-PVSRamCache
   Gets the local computer's non Pool Non Page Bytes
.EXAMPLE
   "Server01", "Server02", "Server03"" | Get-PVSRamCache -Credential Credential

    ComputerName SizeMB
    ------------ ------
    Server01        106
    Server02        108
    Server03        120

.EXAMPLE
   101..128 | % { Get-PVSRamCache -ComputerName "srvwts$_" }

    ComputerName SizeMB
    ------------ ------
    srvwts101       106
    srvwts102       108
    srvwts103       120
    srvwts104       120
    srvwts105       105
    [...]
#>
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true)]
        [Alias("CN")]
        [String[]]
        $ComputerName = $Env:ComputerName,

        [Parameter(Position = 1, Mandatory = $false)]
        [Alias("RunAs")]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    PROCESS
    {
        foreach ($Computer in $Computername)
        {
            $HashTable = @{
                ComputerName = $Computer
                Size         = 0
                Result       = 'Success'
            }

            try
            {
                $CS = New-CimSession -Credential $Credential -ComputerName $Computer
                $QueryResult = CimInstance -Query 'Select PoolNonPagedBytes From Win32_PerfFormattedData_PerfOS_Memory' -CimSession $CS
                $HashTable['Size'] = [math]::truncate(($QueryResult).PoolNonPagedBytes / 1MB)
            }
            catch
            {
                $HashTable['Result'] = $_.Exception.Message
            }

            [pscustomobject]$HashTable
        }
    }
}
