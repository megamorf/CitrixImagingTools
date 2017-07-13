Import-Module $PSScriptRoot\..\..\CitrixImagingTools\CitrixImagingTools.psd1 -Force

Describe 'AddPrefix Filter' {
    InModuleScope CitrixImagingTools {
        Mock -CommandName Get-Date -MockWith {"20170101 00:00:00.0000"}

        function DummyFunction1
        {
            "Test1" | AddPrefix 
        }

        function DummyFunction2
        {
            DummyFunction1
            "Test2" | AddPrefix
        }

        It 'Get correct output for simple function call' {
            $Output = DummyFunction1
            $Output.Count | Should Be 1
            $Output | Should Be "20170101 00:00:00.0000 [DummyFunction1]: Test1"
        }

        It 'Get correct output for nested function call' {
            $Output = DummyFunction2
            $Output.Count | Should Be 2
            $Output[0] | Should Be "20170101 00:00:00.0000 [DummyFunction1]: Test1"
            $Output[1] | Should Be "20170101 00:00:00.0000 [DummyFunction2]: Test2"
        }
    }
}