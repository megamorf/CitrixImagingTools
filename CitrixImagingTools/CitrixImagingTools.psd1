@{

# Script module or binary module file associated with this manifest.
RootModule = 'CitrixImagingTools.psm1'

# Version number of this module.
# Viewing the source in GitHub? This version is updated in the build process and does not reflect the actual version
ModuleVersion = '0.1.0'

# ID used to uniquely identify this module
GUID = '59b64b01-986d-4e68-bf3d-e83450743550'

# Author of this module
Author = 'Sebastian Neumann (@megam0rf)'

# Company or vendor of this module
CompanyName = 'Community'

# Copyright statement for this module
Copyright = '(c) 2017 Sebastian Neumann. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Module to simplify Citrix PVS or MCS based deployments by providing a set of useful helper functions'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
#FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
# CmdletsToExport = '*'

# Variables to export from this module
# VariablesToExport = '*'

# Aliases to export from this module
# AliasesToExport = '*'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
         Tags = @('Citrix', 'PVS', 'Provisioning', 'MCS', 'Provisioning Services', 'Machine Creation Services', 'Imaging')

        # A URL to the license for this module.
         LicenseUri = 'https://github.com/megam0rf/CitrixImagingTools/blob/master/LICENSE'

        # A URL to the main website for this project.
         ProjectUri = 'https://github.com/megam0rf/CitrixImagingTools/'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '
## 0.1.0 (2017-01-29)
* Initial release        
'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}



