Import-Module $PSScriptRoot\..\..\CitrixImagingTools\CitrixImagingTools.psd1 -Force

Describe 'Move-EventLog' {
    InModuleScope CitrixImagingTools {

        Context 'Error Handling' {
            Mock -CommandName New-ItemProperty -MockWith {}
            Mock -CommandName Set-ItemProperty -MockWith {}
            Mock -CommandName New-Item -MockWith {throw "cannot create path"}

            It 'Should throw if destination path cannot be accessed' {
                {Move-EventLog -Destination "TestDrive:\Eventlogs"} | Should -Throw
            }
        }

        Context 'regular' {
            Mock -CommandName New-ItemProperty -MockWith {}
            Mock -CommandName Set-ItemProperty -MockWith {}

            It 'test' {
                Move-EventLog -Destination "TestDrive:\Eventlogs" -Verbose
            }
        }
    }
}
