function Get-WindowsEnvironmentVariable
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,

        [Parameter(Mandatory=$false)]
        [ValidateSet('User','Machine','Process')]
        $Scope
    )

    # No scope means return env vars for all scopes
    if($null -eq $Scope)
    {
        $Scope = @('User','Machine','Process')
    }

    foreach($s in ($Scope | Select-Object -Unique))
    {
        # Convert Scope to title case for pretty output
        $target = (Get-Culture).TextInfo.ToTitleCase($s.tolower())

        $EnvHashtable = [Environment]::GetEnvironmentVariables($target)
        $EnvVariables = $EnvHashtable.GetEnumerator() |
            ForEach-Object { [pscustomobject]@{Name=$_.Key; Scope=$target; Value=$_.Value} } |
            Add-Member -MemberType ScriptMethod -Name ExpandValue -Value { [Environment]::ExpandEnvironmentVariables($this.Value) } -PassThru |
            Sort-Object -Property Name

        if($Name)
        {
            $EnvVariables = $EnvVariables | Where-Object {$Name -contains $_.Name}
        }

        return $EnvVariables
    }    
}
