function Get-Personality
{
    $PersonalityIni = Get-Item -LiteralPath "$env:SystemDrive\Personality.ini" -ErrorAction Stop
    
    Get-IniContent -FilePath $PersonalityIni.FullName
}
