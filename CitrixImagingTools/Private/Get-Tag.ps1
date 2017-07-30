function Get-Tag
{
    [CmdletBinding(DefaultParameterSetName='String')]
    param(
        [Parameter(ParameterSetName='Path',ValueFromPipeline=$true)]
        $Path,

        [Parameter(ParameterSetName='String',ValueFromPipeline=$true)]
        $InputObject
    )

    Begin
    {
        $TagsPattern = ([regex]'(?m)^[\s]{0,15}Tags:(?<Tags>.*)$')
    }

    Process
    {
        foreach ($P in $Path)
        {
            $Result = Select-String -Pattern $TagsPattern -Path $P
            $TagList = $Result.Matches | Foreach-Object {
                $Tags = $_.Groups['Tags'].Value

                if (-not [string]::IsNullOrEmpty($Tags))
                {
                    $Tags.Trim().Split(',')
                }
            }

            [pscustomobject]@{
                Path = $P
                Tags = $TagList
            }
        }
    }
}
