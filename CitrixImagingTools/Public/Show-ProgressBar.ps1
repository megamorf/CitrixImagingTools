function Show-ProgressBar
{
    param(
        [Parameter(Mandatory = $True, ParameterSetName = 'ByProcess')]
        [psobject]$Process,

        [Parameter(Mandatory = $True,ParameterSetName = 'ByName')]
        [string]$ProcessName,

        [Parameter(Mandatory = $True)]
        [string]$ActivityText
    )

    if($ProcessName)
    {
        $Process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    }

    for ($i = 0; $i -lt 100; $i++)
    {
        if ($i -eq '99') {$i = 0}
        $ProcessActive = Get-Process -Id $Process.Id -ErrorAction SilentlyContinue

        if ($null -eq $ProcessActive)
        {
            $i = 100
            Write-Progress -Activity 'Finished...waiting 10 seconds for next operation' -PercentComplete $i -Status 'Finished.'
            Start-Sleep -Seconds 10
            Write-Progress -Activity 'Done' -Status 'Done' -Completed
            break
        }
        else
        {
            Start-Sleep -Seconds 1
            Write-Progress -Activity "$ActivityText" -PercentComplete $i -Status 'Please wait...'
        }
    }
}
