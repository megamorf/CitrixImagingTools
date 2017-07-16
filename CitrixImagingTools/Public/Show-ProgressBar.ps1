function Show-ProgressBar
{
    param(
        [Parameter(Mandatory = $True)]
        [string]$ProcessName,

        [Parameter(Mandatory = $True)]
        [string]$ActivityText
    )

    Start-Sleep -Seconds 5

    for ($i = 0; $i -lt 100; $i++)
    {
        if ($i -eq '99') {$i = 0}
        $ProcessActive = Get-Process $ProcessName -ErrorAction SilentlyContinue

        if ($null -eq $ProcessActive)
        {
            $i = 100
            Write-Progress -Activity 'Finish...wait for next operation in 10 seconds' -PercentComplete $i -Status 'Finish.'
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
