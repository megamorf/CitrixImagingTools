Import-Module $PSScriptRoot\..\..\CitrixImagingTools\CitrixImagingTools.psd1 -Force

Describe 'Disable-Service' {
    InModuleScope CitrixImagingTools {

        Context 'Unsupported OS' {
            Mock -CommandName Get-OperatingSystemFamily -MockWith {'Windows Server 2008 R2'}
            Mock -CommandName Stop-Service -MockWith {}
            Mock -CommandName Set-Service -MockWith {}

            Disable-Service 3> 'TestDrive:\warning.txt'

            It 'Should show warning' {
                'TestDrive:\warning.txt' | Should Contain "No supported OS found"
            }

            It 'Should not disable services' {
                Assert-MockCalled -CommandName Stop-Service -Times 0
            }
        }

        Context 'Supported OS and service file is valid' {
            Mock -CommandName Get-OperatingSystemFamily -MockWith {'Windows Server 2016'}
            Mock -CommandName Stop-Service -MockWith {"DummyServiceName"} -ParameterFilter {$Name -ne "SvcDoesNotExist"}
            Mock -CommandName Stop-Service -MockWith {throw "SvcDoesNotExist"} -ParameterFilter {$Name -eq "SvcDoesNotExist"}
            Mock -CommandName Set-Service -MockWith {}
            Mock -CommandName Import-Csv -MockWith {
                'ServiceName;ServiceDescription;Notes
                SharedAccess;Internet Connection Sharing;
                NcaSvc;Network Connectivity Assistant;
                CscService;Offline Files;
                defragsvc;Optimize Drives;
                SstpSvc;Secure Socket Tunneling Protocol Service;
                SvcDoesNotExist;Fake Description;' | ConvertFrom-Csv -Delimiter ';'
            }

            It 'Should disable existing services' {
                Disable-Service
                Assert-MockCalled -CommandName Set-Service -Times 5
            }

            It 'Should disable all services except the excluded ones' {
                Disable-Service -Exclude 'SharedAccess', 'defragsvc'
                Assert-MockCalled -CommandName Set-Service -Times 8
            }
        }

        Context 'Supported OS and service file is invalid' {
            Mock -CommandName Get-OperatingSystemFamily -MockWith {'Windows Server 2016'}
            Mock -CommandName Stop-Service -MockWith {"DummyServiceName"}
            Mock -CommandName Set-Service -MockWith {}
            Mock -CommandName Import-Csv -MockWith {
                'ServiceName;ServiceDescriptionN;Notes
                SharedAccess;Internet Connection Sharing;
                NcaSvc;Network Connectivity Assistant;
                CscService;Offline Files;
                defragsvc;Optimize Drives;
                SstpSvc;Secure Socket Tunneling Protocol Service;' | ConvertFrom-Csv -Delimiter ';'
            }

            It 'Should stop with error when file is invalid' {
                {Disable-Service -Verbose} | Should -Throw -ExpectedMessage "Error importing service list - field [ServiceDescription] not found"
                Assert-MockCalled -CommandName Import-Csv -Times 1
                Assert-MockCalled -CommandName Set-Service -Times 0
            }
        }
    }
}
