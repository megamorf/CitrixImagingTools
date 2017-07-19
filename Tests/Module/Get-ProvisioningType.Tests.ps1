Import-Module $PSScriptRoot\..\..\CitrixImagingTools\CitrixImagingTools.psd1 -Force

Describe 'Get-ProvisioningType' {
    InModuleScope CitrixImagingTools {

        Context 'Error Handling' {
            It 'Throws error if no FMA Agent found' {
                Mock -CommandName Get-Service -MockWith {} -ParameterFilter {$Name -eq 'BrokerAgent'}
                {Get-ProvisioningType} | Should throw
            }
        }

        Context 'Type Detection' {
            Mock -CommandName Get-Service -MockWith {"Service"} -ParameterFilter {$Name -eq 'BrokerAgent'}

            It 'Returns "PVS" when personality.ini contains "$Diskname="' {
                Mock -CommandName Select-String -MockWith {$true}
                Get-ProvisioningType | Should Be 'PVS'
            }

            It 'Returns "MCS" when personality.ini does not contain "$Diskname="' {
                Mock -CommandName Select-String -MockWith {}
                Get-ProvisioningType | Should Be 'MCS'
            }

            It 'Returns "Manual" when personality.ini does not exist' {
                Mock -CommandName Select-String -MockWith {throw "file not found"}
                Get-ProvisioningType | Should Be 'Manual'
            }
        }

    }
}
