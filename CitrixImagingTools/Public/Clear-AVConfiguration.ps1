function Clear-AVConfiguration
{
    [CmdletBinding(DefaultParameterSetName='Sophos', SupportsShouldProcess=$true, ConfirmImpact='High')]
    param(
        [Parameter(ParameterSetName='Sophos')]
        [switch] $Sophos
    )

    $EA = @{ErrorAction = 'Ignore'}

    if($Sophos.isPresent)
    {
        # https://community.sophos.com/kb/en-us/12561
        
        if ($PSCmdlet.ShouldProcess('[Sophos]', '1. Stop services'))
        {
            $Services = 'Sophos Message Router', 'Sophos Agent', 'Sophos AutoUpdate Service', 'Sophos Web Intelligence Service', 'Sophos Web Filter'
            $Services.foreach{ Stop-Service @EA -DisplayName $_ -PassThru -Force | Set-Service -StartupType Disabled }
        }

        if ($PSCmdlet.ShouldProcess('[Sophos]', '2. Delete Registry pkc/pkp entries'))
        {
            Remove-ItemProperty @EA -Path 'HKLM:\SOFTWARE\Wow6432Node\Sophos\Remote Management System\ManagementAgent\Private' -Name 'pkp'  
            Remove-ItemProperty @EA -Path 'HKLM:\SOFTWARE\Wow6432Node\Sophos\Remote Management System\ManagementAgent\Private' -Name 'pkc'  
            Remove-ItemProperty @EA -Path 'HKLM:\SOFTWARE\Wow6432Node\Sophos\Messaging System\Router\Private' -Name 'pkp'  
            Remove-ItemProperty @EA -Path 'HKLM:\SOFTWARE\Wow6432Node\Sophos\Messaging System\Router\Private' -Name 'pkc'
        }
        
        if ($PSCmdlet.ShouldProcess('[Sophos]', '3. Delete Machine ID'))
        {
            Remove-Item @EA -Path 'C:\ProgramData\Sophos\AutoUpdate\machine_ID.txt' -Force
            Remove-Item @EA -Path 'C:\ProgramData\Sophos\AutoUpdate\data\machine_ID.txt' -Force
        }

        if ($PSCmdlet.ShouldProcess('[Sophos]', '4. Delete Registry Web Control ID'))
        {        
            Remove-ItemProperty @EA -Path 'HKLM:\SOFTWARE\Wow6432Node\Sophos\Web Intelligence\Web Control' -Name 'EndpointId'
        }
    }
}