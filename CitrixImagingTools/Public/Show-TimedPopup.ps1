function Show-TimedPopup
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [int]$TimeoutSeconds = 30,

        [string]$Title,

        [ValidateSet('OK', 'OKCancel', 'AbortIgnoreRetry', 'YesNoCancel', 'YesNo', 'RetryCancel')]
        [string]$ButtonType = 'OK',

        [ValidateSet('Critical', 'Question', 'Exclamation', 'Information', $null)]
        [string]$IconType = $null
    )

    # Types
    $IconTypes = @{
        'Critical'    = 16
        'Question'    = 32
        'Exclamation' = 48
        'Information' = 64
    }

    $ButtonTypes = @{
        'OK'               = 0
        'OKCancel'         = 1
        'AbortIgnoreRetry' = 2
        'YesNoCancel'      = 3
        'YesNo'            = 4
        'RetryCancel'      = 5
    }

    $WSHell = New-Object -ComObject WScript.Shell

    $Type = $ButtonTypes[$ButtonType] + $IconTypes[$IconType]

    $Return = $WSHell.Popup($Message, $TimeoutSeconds, $Title, $Type)

    return $Return
}