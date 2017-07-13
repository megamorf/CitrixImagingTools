function Invoke-DiskpartScript
{
    param(
        [ValidateNotNullOrEmpty()]
        $FilePath
    )

    Test-Path -Path $FilePath -PathType Leaf -ErrorAction Stop | Out-Null
    diskpart.exe /s $FilePath
}