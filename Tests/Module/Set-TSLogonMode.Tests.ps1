Import-Module $PSScriptRoot\..\..\CitrixImagingTools\CitrixImagingTools.psd1 -Force

#WIP
Describe 'Set-TSLogonMode' {
    InModuleScope CitrixImagingTools {

        Context 'ToDo' {
            function Get-CimInstance {}
            function Set-CimInstance {param([Parameter(ValueFromPipeline = $true)]$InputObject) $input}
            Mock -CommandName Get-CimInstance -MockWith { @{} }
            #Mock -CommandName Set-CimInstance -MockWith { $args }

            It 'Disables Logon' -Skip {
                $f = Set-TSLogonMode -Mode ProhibitLogons
                write-verbose ($f | ft -au | out-string) -Verbose
                $f | SHould Not BeNullOrEmpty
            }
        }
    }
}
