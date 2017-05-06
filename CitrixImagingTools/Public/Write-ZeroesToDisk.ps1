function Write-ZeroesToDisk
{
    <#
    .SYNOPSIS
     Writes a large file full of zeroes to a volume in order to allow a storage
     appliance to reclaim unused space.

    .DESCRIPTION
     Creates a file called ZeroFile.tmp on the specified volume that fills the
     volume up to leave only the percent free value (default is 5%) with zeroes.
     This allows a storage appliance that is thin provisioned to mark that drive
     space as unused and reclaim the space on the physical disks.
 
    .PARAMETER Root
     The folder to create the zeroed out file in.  This can be a drive root (C:\)
     or a mounted folder (M:\mounteddisk).  This must be the root of the mounted
     volume, it cannot be an arbitrary folder within a volume.
 
    .PARAMETER PercentFree
     A float representing the percentage of total volume space to leave free.  The
     default is .05 (5%)

    .EXAMPLE
     PS> Write-ZeroesToDisk -Root "C:\"
 
     This will create a file of all zeroes called C:\ZeroFile.tmp that will fill the
     c drive up to 95% of its capacity.
 
    .EXAMPLE
     PS> Write-ZeroesToDisk -Root "C:\MountPoints\Volume1" -PercentFree .1
 
     This will create a file of all zeroes called
     C:\MountPoints\Volume1\ZeroFile.tmp that will fill up the volume that is
     mounted to C:\MountPoints\Volume1 to 90% of its capacity.

    .EXAMPLE
     PS> Get-WmiObject Win32_Volume -Filter "drivetype=3" | Write-ZeroesToDisk
 
     This will get a list of all local disks (type=3) and fill each one up to 95%
     of their capacity with zeroes.
 
    .NOTES
     You must be running as a user that has permissions to write to the root of the
     volume you are running this script against. This requires elevated privileges
     using the default Windows permissions on the C drive.

    #>
    param(
      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
      [ValidateNotNullOrEmpty()]
      [Alias("Name")]
      $Root,

      [Parameter(Mandatory=$false)]
      [ValidateRange(0,1)]
      [float]
      $PercentFree = .05
    )

    Process
    {
      #"Convert the $Root value to a valid WMI filter string"
      $FixedRoot = ($Root.Trim("\") -replace "\\","\\") + "\\"
      $FileName = "ZeroFile.tmp"
      $FilePath = Join-Path $Root $FileName
	  write-BISFlog -Msg "FilePath: $FilePath"
  
      write-BISFlog -Msg "Check and make sure the file doesn't already exist so we don't clobber someone's data"
      if( (Test-Path $FilePath) ) {
        write-BISFlog -Msg "The file $FilePath already exists, please delete the file and try again" -Type E
      } else {
        write-BISFlog -Msg "Get a reference to the volume so we can calculate the desired file size later"
        $Volume = gwmi win32_volume -filter "name='$FixedRoot'"
        write-BISFlog -Msg "Volume: $Volume"
        if($Volume) {
          write-BISFlog -Msg "I have not tested for the optimum IO size , 64kb is what sdelete.exe uses"
          $ArraySize = 64kb
		  write-BISFlog -Msg "ArraySize: $ArraySize"

          write-BISFlog -Msg "Calculate the amount of space to leave on the disk"
          $SpaceToLeave = $Volume.Capacity * $PercentFree
          write-BISFlog -Msg "SpaceToLeave: $SpaceToLeave"
		  
		  write-BISFlog -Msg "Calculate the file size needed to leave the desired amount of space"
          $FileSize = $Volume.FreeSpace - $SpacetoLeave
          write-BISFlog -Msg "FileSize: $FileSize"

		  write-BISFlog -Msg "Create an array of zeroes to write to disk"
          $ZeroArray = new-object byte[]($ArraySize)
          
          write-BISFlog -Msg "Open a file stream to our file $FilePath"
          $Stream = [io.File]::OpenWrite($FilePath)
          #Start a try/finally block so we don't leak file handles if any exceptions occur
          try {
            #Keep track of how much data we've written to the file
            $CurFileSize = 0
            $a=0
            while($CurFileSize -lt $FileSize) {
				$a = (100* $CurFileSize)/$FileSize
				$display= "{0:N2}" -f $a #reduce display to 2 digits on the right side of the numeric 
				Write-Progress -Activity "Zero Out Free Space is running $display %" -PercentComplete $a -Status "Please wait..."
				#Write the entire zero array buffer out to the file stream
				$Stream.Write($ZeroArray,0, $ZeroArray.Length)
				#Increment our file size by the amount of data written to disk
				$CurFileSize += $ZeroArray.Length     
            }
          } finally {
            write-BISFlog -Msg "always close our file stream, even if an exception occurred"
            $a=100
            Write-Progress -Activity "Finish..." -PercentComplete $a -Status "Finish."
        
            
            if($Stream) {
              $Stream.Close()
            }
            write-BISFlog -Msg "always delete the file if we created it, even if an exception occurred"
            if( (Test-Path $FilePath) ) {
              del $FilePath
            }
            Write-Progress "Done" "Done" -completed	
          }
        } else {
          write-BISFlog -Msg "Unable to locate a volume mounted at $Root" -Type E
        }
      }
    }
}
