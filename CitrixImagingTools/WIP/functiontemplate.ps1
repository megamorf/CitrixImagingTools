function Do-Something
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [OutputType()]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    Write-Verbose -Message ("My Message" | AddPrefix)

    if ($PSCmdlet.ShouldProcess("target", "action"))
    {

    }
}
