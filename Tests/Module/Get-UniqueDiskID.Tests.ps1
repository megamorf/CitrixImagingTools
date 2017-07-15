Import-Module $PSScriptRoot\..\..\CitrixImagingTools\CitrixImagingTools.psd1 -Force

#WIP
Describe 'Get-UniqueDiskID' {
    InModuleScope CitrixImagingTools {
        function Get-Partition {}
        Mock -CommandName Get-Partition -MockWith {[pscustomobject]@{DiskNumber = 0}} -ParameterFilter {$DriveLetter -ne 'z'}
        Mock -CommandName Get-Partition -MockWith {throw 'unknown drive!'} -ParameterFilter {$DriveLetter -eq 'z'}
        Mock -CommandName Invoke-DiskpartScript -MockWith { "Disk ID: 7DCE7601"}

        It 'Should return output for mapped drive letter' {
            $MappedDriveLetter = "d"

            $Output = Get-UniqueDiskID -DriveLetter $MappedDriveLetter
            $Output.DriveLetter | Should BeExactly $MappedDriveLetter.ToUpper()
            $Output.DiskNumber | Should Be 0
            $Output.UniqueDiskID | Should BeExactly '7DCE7601'
        }

        It 'Should throw if provided with unmapped drive letter' {
            $UnmappedDriveLetter = "z"

            {Get-UniqueDiskID -DriveLetter $UnmappedDriveLetter} | Should -Throw
        }
    }
}