﻿
#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
    $ModuleRoot = $PSScriptRoot

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.FullName
        }
        Catch
        {
            Write-Error "Failed to import function $($import.FullName): $_"
        }
    }

Export-ModuleMember -Function $Public.Basename