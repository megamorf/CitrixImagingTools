function Get-Tag2
{
    [CmdletBinding()]
    param(
        $InputObject
    )

    Begin
    {
        $TagsPattern = ([regex]'(?m)^[\s]{0,15}Tags:(?<Tags>.*)$')
    }

    Process
    {
        foreach ($I in $InputObject)
        {
            $Result = Select-String -Pattern $TagsPattern -InputObject $I
            $TagList = $Result.Matches | Foreach-Object {
                try
                {
                    $Tags = $_.Groups['Tags'].Value

                    if (-not [string]::IsNullOrEmpty($Tags))
                    {
                        $Tags.Trim().Split(',')
                    }
                }
                catch
                {
                    $null
                }
            }

            $TagList
        }
    }
}
