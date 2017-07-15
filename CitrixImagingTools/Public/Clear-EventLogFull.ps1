function Clear-EventLogFull
{
   [CmdletBinding()]
   param($ComputerName="localhost")

   $Logs = Get-EventLog -ComputerName $ComputerName -List | Select-Object -ExpandProperty Log
   Clear-EventLog -ComputerName $ComputerName -LogName $Logs
   Get-EventLog -ComputerName $ComputerName -List
}