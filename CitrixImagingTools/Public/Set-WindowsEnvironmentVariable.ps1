Function Set-WindowsEnvironmentVariable
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [String]$Name,

        [Parameter(Mandatory = $true)]
        [String]$Value,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Process','Machine','User')]
        [String]$Scope = 'Process',

        [switch]$Passthru
    )

    if ($PSCmdlet.ShouldProcess("[$Scope]::$Name", $Value))
    {
        
        $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

        if($Scope -eq 'Machine')
        {
            if(-not $IsAdmin)
            {
                throw "You need administrator privileges to modify variables in the 'Machine' scope"
            }
        }

        try
        {
            $OldValue = [Environment]::GetEnvironmentVariable($Name,$Scope)
            $Output = [PSCustomObject][ordered]@{
                Name = $Name
                Scope = $Scope
                OldValue = $OldValue
                NewValue = $Value
            }

            [Environment]::SetEnvironmentVariable($Name, $Value, $Scope)

            if($Passthru)
            {
                $Output
            }
        }
        catch
        {}
    }
}    
