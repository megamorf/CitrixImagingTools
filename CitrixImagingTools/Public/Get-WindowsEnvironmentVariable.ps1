function Get-WindowsEnvironmentVariable
{
    <#
    .SYNOPSIS
        Returns environment variables.

    .DESCRIPTION
        Returns one or more variables from all or specific scopes.

    .PARAMETER Name
        Specify one or more variable names. Doesn't support wildcards

    .PARAMETER Scope
        Specify an environment scope. Defaults to all scopes.

    .EXAMPLE
        Get-WindowsEnvironmentVariable

        Returns environment variables from the User, Machine and
        Process scopes.

    .EXAMPLE
        Get-WindowsEnvironmentVariable -Name TEMP

        Name Scope   Value
        ---- -----   -----
        TEMP User    C:\Users\testuser\AppData\Local\Temp
        TEMP Machine C:\Windows\TEMP
        TEMP Process C:\Users\testuser\AppData\Local\Temp\4

        Returns a specific variable from all scopes.

    .EXAMPLE
        Get-WindowsEnvironmentVariable -Name TEMP -Scope User

        Name Scope   Value
        ---- -----   -----
        TEMP User    C:\Users\testuser\AppData\Local\Temp

        Returns a specific variable from a specific scope.

    .NOTES
        ToDo: add tags, author info
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateSet('User', 'Machine', 'Process')]
        $Scope
    )

    # No scope means return env vars for all scopes
    if ($null -eq $Scope)
    {
        $Scope = @('User', 'Machine', 'Process')
    }

    foreach ($s in ($Scope | Select-Object -Unique))
    {
        # Convert Scope to title case for pretty output
        $target = (Get-Culture).TextInfo.ToTitleCase($s.tolower())

        $EnvHashtable = [Environment]::GetEnvironmentVariables($target)
        $EnvVariables = $EnvHashtable.GetEnumerator() |
            ForEach-Object { [pscustomobject]@{Name = $_.Key; Scope = $target; Value = $_.Value} } |
            Add-Member -MemberType ScriptMethod -Name ExpandValue -Value { [Environment]::ExpandEnvironmentVariables($this.Value) } -PassThru |
            Sort-Object -Property Name

        if ($Name)
        {
            $EnvVariables = $EnvVariables | Where-Object {$Name -contains $_.Name}
        }

        $EnvVariables
    }
}
