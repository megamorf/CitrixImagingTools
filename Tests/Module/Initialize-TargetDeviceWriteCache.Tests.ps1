Import-Module $PSScriptRoot\..\..\CitrixImagingTools\CitrixImagingTools.psd1 -Force

Describe 'Initialize-TargetDeviceWriteCache' {
    InModuleScope CitrixImagingTools {

        #region create function stubs to mock non-existant functions
        function Get-Volume { param([Parameter(ValueFromPipeline)]$DriveLetter) }
        function Set-Volume {}
        function Set-Partition {}
        function Get-Partition {}
        function Get-Disk {}
        function Initialize-Disk {}
        function Format-Volume {}
        function New-Partition {}
        #endregion

        Context 'Error Handling' {
            It 'Throws error if not a valid target device' {
                Mock -CommandName Get-vDiskInformation -MockWith {[pscustomobject]@{IsValidTargetDevice = $false}}
                {Initialize-TargetDeviceWriteCache} | Should -throw -ExpectedMessage 'Please install target device drivers first. Aborting...'
            }

            It 'Throws error if drive letter is already taken' {
                Mock -CommandName Get-vDiskInformation -MockWith {[pscustomobject]@{IsValidTargetDevice = $true}}
                Mock -CommandName Get-PSDrive -MockWith {$true} -ParameterFilter {($PSProvider -eq "FileSystem") -and ($Name -eq 'D')}
                {Initialize-TargetDeviceWriteCache} | Should -Throw -ExpectedMessage 'Drive letter D is currently in use. Please remap the blocking device or choose a different drive letter. Aborting...'
            }
        }

        Context 'When drive label is wrong' {
            $DriveLabel = "TestLabel"
            Mock -CommandName Get-vDiskInformation -MockWith {[pscustomobject]@{IsValidTargetDevice = $true; vDiskMode = 'Shared'}}
            Mock -CommandName Get-PSDrive -MockWith {$false}
            Mock -CommandName Set-Volume -MockWith {}
            Mock -CommandName Set-UniqueDiskId -MockWith {}
            Mock -CommandName Get-Partition -MockWith { "partition" }
            Mock -CommandName Set-Partition -MockWith {}
            MOck -CommandName New-Partition -MockWith {}
            Mock -CommandName Get-Volume -MockWith {[pscustomobject]@{FileSystem = 'NTFS'; FileSystemLabel = 'Not TestLabel'; DriveLetter = 'D'}}
            Mock -CommandName Get-CimInstance -MockWith {"disk"} -ParameterFilter {$Filter -eq "MediaType = 'Fixed hard disk media'"}
            Mock -CommandName Format-Volume -MockWith {}

            Initialize-TargetDeviceWriteCache -DriveLabel $DriveLabel #-Verbose

            It 'Does not format and set up the disk' {
                Assert-MockCalled -CommandName New-Partition -Exactly 0
                Assert-MockCalled -CommandName Format-Volume -Exactly 0
            }

            It 'Sets the new drive label' {
                Assert-MockCalled -CommandName Set-Volume -Exactly 1
            }

            It 'Does not set drive letter' {
                Assert-MockCalled -CommandName Set-Partition -Exactly 0
            }

            It 'Sets the unique disk id' {
                Assert-MockCalled -CommandName Set-UniqueDiskId -Exactly 1
            }
        }

        Context 'When drive letter is wrong' {
            $DriveLetter = "E"
            Mock -CommandName Get-vDiskInformation -MockWith {[pscustomobject]@{IsValidTargetDevice = $true; vDiskMode = 'Shared'}}
            Mock -CommandName Get-PSDrive -MockWith {$false}
            Mock -CommandName Set-Volume -MockWith {}
            Mock -CommandName Set-UniqueDiskId -MockWith {}
            Mock -CommandName Get-Partition -MockWith { "partition" }
            Mock -CommandName Set-Partition -MockWith {}
            MOck -CommandName New-Partition -MockWith {}
            Mock -CommandName Get-Volume -MockWith {[pscustomobject]@{FileSystem = 'NTFS'; FileSystemLabel = 'WriteCache'; DriveLetter = 'D'}}
            Mock -CommandName Get-CimInstance -MockWith {"disk"} -ParameterFilter {$Filter -eq "MediaType = 'Fixed hard disk media'"}
            Mock -CommandName Format-Volume -MockWith {}

            Initialize-TargetDeviceWriteCache -DriveLetter $DriveLetter #-Verbose

            It 'Does not format and set up the disk' {
                Assert-MockCalled -CommandName New-Partition -Exactly 0
                Assert-MockCalled -CommandName Format-Volume -Exactly 0
            }

            It 'Does not set the new drive label' {
                Assert-MockCalled -CommandName Set-Volume -Exactly 0
            }

            It 'Sets the drive letter' {
                Assert-MockCalled -CommandName Set-Partition -Exactly 1
            }

            It 'Sets the unique disk id' {
                Assert-MockCalled -CommandName Set-UniqueDiskId -Exactly 1
            }
        }

        Context 'When the disk is new' {

            # Pass preflight checks
            Mock -CommandName Get-vDiskInformation -MockWith {[pscustomobject]@{IsValidTargetDevice = $true; vDiskMode = 'Shared'}}
            Mock -CommandName Get-PSDrive -MockWith {$false}

            # Mock disk mgmt Cmdlets
            Mock -CommandName Get-Partition -MockWith { "partition" }
            Mock -CommandName New-Partition -MockWith { "new partition" }
            Mock -CommandName Set-Partition -MockWith {}
            Mock -CommandName Set-Volume -MockWith {}
            Mock -CommandName Format-Volume -MockWith {}
            # Return unexpected/expected volume information based on partition input
            Mock -CommandName Get-Volume -MockWith {[pscustomobject]@{FileSystem = 'NotNTFS'; FileSystemLabel = ''; DriveLetter = ''}} -ParameterFilter {$DriveLetter -ne "new partition"}
            Mock -CommandName Get-Volume -MockWith {[pscustomobject]@{FileSystem = 'NTFS'; FileSystemLabel = 'WriteCache'; DriveLetter = 'D'}} -ParameterFilter {$DriveLetter -eq "new partition"}

            # Return one item as write cache hard disk            
            Mock -CommandName Get-CimInstance -MockWith {"disk"} -ParameterFilter {$Filter -eq "MediaType = 'Fixed hard disk media'"}
            
            # Mock our function
            Mock -CommandName Set-UniqueDiskId -MockWith {}

            Initialize-TargetDeviceWriteCache #-Verbose

            It 'Formats and sets up the disk' {
                Assert-MockCalled -CommandName New-Partition -Exactly 1
                Assert-MockCalled -CommandName Format-Volume -Exactly 1
            }

            It 'Does not set the new drive label' {
                Assert-MockCalled -CommandName Set-Volume -Exactly 0
            }

            It 'Does not set the drive letter' {
                Assert-MockCalled -CommandName Set-Partition -Exactly 0
            }

            It 'Sets the unique disk id' {
                Assert-MockCalled -CommandName Set-UniqueDiskId -Exactly 1
            }
        }

    }
}