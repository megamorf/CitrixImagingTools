Function Set-TSLogonMode
{
    <#
	.SYNOPSIS
	Sets a logon mode on a Remote Desktop Session Host (RDSH).

	.DESCRIPTION
	Configures a RDSH logon mode via CIM.

	.PARAMETER Mode
	There are 4 logon modes:

    AllowLogons (default)
        - default setting that allows every authenticated user to log on

    ProhibitNewLogonsUntilRestart
        - new user log ons are denied until a reboot
        - exisiting sessions can be disconnected and reconnected 
    
    ProhibitNewLogons
        - new user log ons are denied
        - exisiting sessions can be disconnected and reconnected 
    
    ProhibitLogons
        - all log ons are denied indefinitely

	.PARAMETER Computername
	Computer(s) to set the logon mode for. If not specified, the local computer will be used.
	
	.NOTES
	Original Author: Sebastian Neumann (@megam0rf)
	Tags: RDSH
	
	Copyright: (C) Sebastian Neumann
	License: GNU GPL v3 https://opensource.org/licenses/GPL-3.0

	.LINK
	https://github.com/megamorf/CitrixImagingTools/blob/master/CitrixImagingTools/Public/Set-TSLogonMode.ps1

	.EXAMPLE
	Set-TSLogonMode -Mode ProhibitNewLogonsUntilRestart
	Drains the RDSH by preventing log on attempts, existing sessions are unaffected.

	.EXAMPLE
	Get-Content .\serverlist.txt | Set-TSLogonMode -Mode ProhibitLogons
	Configures the logon mode to deny all logon attempts for all computers in serverlist.txt. 

	#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateSet('AllowLogons','ProhibitNewLogonsUntilRestart','ProhibitNewLogons','ProhibitLogons')]
        [ValidateNotNullOrEmpty()]
        [string]$Mode,
        
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=1)]
        [Alias("__Server","IPAddress","CN","dnshostname")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Computername = '.',

        [Parameter(Position=2)]
        [System.Management.Automation.PSCredential]$Credential
    )

    BEGIN
    {
        $TSSettingsParams = @{
            Namespace = 'root\CIMV2\terminalservices'
            ClassName = 'Win32_TerminalServiceSetting'
            Verbose = $false
        }
    }

    PROCESS
    {
        foreach($computer in $Computername)
        {          
            $TSSettings = Get-CimInstance @TSSettingsParams -ComputerName $Computer -Credential $Credential

            switch ($Mode)
            {
                'AllowLogons' { 
                    $TSSettings.Logons = 0
                    $TSSettings.SessionBrokerDrainMode = 0
                    break
                }
                'ProhibitNewLogOnsUntilRestart' {
                    $TSSettings.Logons = 0
                    $TSSettings.SessionBrokerDrainMode = 1
                    break
                }
                'ProhibitNewLogOns' {
                    $TSSettings.Logons = 0
                    $TSSettings.SessionBrokerDrainMode = 2
                    break
                }
                'ProhibitLogOns' {
                    $TSSettings.Logons = 1
                }
            }
            
            if ($PSCmdlet.ShouldProcess("Set Logon Mode to $Mode", "$computer"))
            {
                $TSSettings | Set-CimInstance -ComputerName $Computer -Credential $Credential
            }   
        }
    }
}
