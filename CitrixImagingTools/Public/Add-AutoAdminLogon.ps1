Function Add-AutoAdminLogon
{

}

<#

LSA Secrets are a protected area of storage used to store internal private data. Data is stored in the registry under HKLM\SECURITY\Policy\Secrets, and this registry key has restricted ACL’s so it is not visible in regedit.exe using a normal user accounts. However, the DefaultPassword key can be decoded by any administrator using a simple Win32 API call.
Any administrator can decode the pw

The Local Security Authority (LSA) in Windows is designed to manage a systems security policy, auditing, logging users on to the system, and storing private data such as service account passwords.

The LSA secrets are stored under the HKLM:\Security\Policy\Secrets key. This key contains additional subkeys that store encrypted secrets. The HKLM:\Security\Policy\Secrets key is not accessible from regedit or other tools by default, but we can access it by running the Enable-TSDuplicateToken function described in yesterday’s blog, Use PowerShell to Duplicate Process Tokens via P/Invoke.
#>