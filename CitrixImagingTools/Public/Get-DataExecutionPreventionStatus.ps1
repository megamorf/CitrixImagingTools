function Get-DataExecutionPreventionStatus
{
    <#
    .SYNOPSIS
        Gets the current DEP status.

    .DESCRIPTION
        Gets the current DEP status.

        Data Execution Prevention (DEP) is a set of hardware and software technologies
        that perform additional checks on memory to help prevent malicious code from
        running on a system.

        The primary benefit of DEP is to help prevent code execution from data pages.
        Typically, code is not executed from the default heap and the stack. Hardware-enforced
        DEP detects code that is running from these locations and raises an exception when
        execution occurs. Software-enforced DEP can help prevent malicious code from taking
        advantage of exception-handling mechanisms in Windows.

    .PARAMETER ListAvailable
        Lists all available DEP options.

    .EXAMPLE
        Get-DataExecutionPreventionStatus | Format-List

        PolicyLevel : OptIn
        IsDefault   : True
        Description : This setting is the default configuration. On systems with processors
                      that can implement hardware-enforced DEP, DEP is enabled by default for
                      limited system binaries and programs that "opt-in." With this option,
                      only Windows system binaries are covered by DEP by default.

    .EXAMPLE
        Get-DataExecutionPreventionStatus -ListAvailable | Format-List

        List all available DEP options.

    .NOTES
        Original Author: Sebastian Neumann (@megam0rf)
        Tags: Runtime, State, Security

    .LINK
        https://support.microsoft.com/en-us/help/875352/a-detailed-description-of-the-data-execution-prevention-dep-feature-in
    .LINK
        https://blogs.technet.microsoft.com/srd/2009/06/12/understanding-dep-as-a-mitigation-technology-part-1/
    #>
    [CmdletBinding()]
    param(
        [switch] $ListAvailable
    )

    $MappingTable = @{
        0 = [ordered]@{
            PolicyLevel = "AlwaysOff";
            IsDefault   = $false;
            Description = 'This setting does not provide any DEP coverage for any part of the system, regardless of hardware DEP support.'
        }
        1 = [ordered]@{
            PolicyLevel = "AlwaysOn";
            IsDefault   = $false;
            Description = 'This setting provides full DEP coverage for the whole system. All processes always run with DEP applied. The exceptions list to exempt specific programs from DEP protection is not available. System compatibility fixes for DEP do not take effect. Programs that have been opted-out by using the Application Compatibility Toolkit run with DEP applied.'
        }
        2 = [ordered]@{
            PolicyLevel = "OptIn";
            IsDefault   = $true;
            Description = 'This setting is the default configuration. On systems with processors that can implement hardware-enforced DEP, DEP is enabled by default for limited system binaries and programs that "opt-in." With this option, only Windows system binaries are covered by DEP by default.'
        }
        3 = [ordered]@{
            PolicyLevel = "OptOut";
            IsDefault   = $false;
            Description = 'DEP is enabled by default for all processes. You can manually create a list of specific programs that do not have DEP applied by using the System dialog box in Control Panel. Information technology (IT) professionals can use the Application Compatibility Toolkit to "opt-out" one or more programs from DEP protection. System compatibility fixes, or shims, for DEP do take effect.'
        }

    }

    if ($ListAvailable.IsPresent)
    {
        $MappingTable.GetEnumerator() | ForEach-Object {
            [pscustomobject]$_.Value
        }
    }
    else
    {
        $Result = Get-CimInstance -ClassName win32_operatingsystem -Property DataExecutionPrevention_SupportPolicy
        $PolicyID = [int]($Result.DataExecutionPrevention_SupportPolicy)
        [pscustomobject]($MappingTable[$PolicyID])
    }

}
