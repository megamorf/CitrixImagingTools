Function Get-OperatingSystemFamily
{
    [OutputType([string])]
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Resolve')]
        [ValidateNotNullOrEmpty()]
        $Version,

        [Parameter(ParameterSetName = 'Resolve')]
        [switch]$IsClientOS
    )

    # https://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx

    if ($PSCmdlet.ParameterSetName -eq 'Resolve')
    {
        $IsServer = (-not $IsClientOS)
    }
    else
    {
        $OS = Get-CimInstance -ClassName Win32_OperatingSystem
        $IsServer = $OS.ProductType -ne 1 # 1=Workstation
        $Version = $OS.Version
    }

    if ($IsServer)
    {
        switch -wildcard ($Version)
        {
            '10.0*' {'Windows Server 2016'; break}
            '6.3*' {'Windows Server 2012 R2'; break}
            '6.2*' {'Windows Server 2012'; break}
            '6.1*' {'Windows Server 2008 R2'; break}
            '6.0*' {'Windows Server 2008'; break}
            '5.2*' {'Windows Server 2003 R2'; break}
        }
    }
    else
    {
        switch -wildcard ($Version)
        {
            '10.0*' {'Windows 10'; break}
            '6.3*' {'Windows 8.1'; break}
            '6.2*' {'Windows 8'; break}
            '6.1*' {'Windows 7'; break}
            '6.0*' {'Windows Vista'; break}
            '5.2*' {'Windows XP 64-Bit Edition'; break}
            '5.1*' {'Windows XP'; break}
        }
    }
}
