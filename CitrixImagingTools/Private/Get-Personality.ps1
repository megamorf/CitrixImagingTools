function Get-Personality
{
    $PersonalityIni = Get-Item -LiteralPath "$env:SystemDrive\Personality.ini" -ErrorAction Stop

    Import-IniFile -FilePath $PersonalityIni.FullName
}
