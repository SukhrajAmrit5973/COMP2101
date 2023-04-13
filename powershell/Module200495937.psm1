'$env:path += ";$home/documents/github/comp2101/powershell"' >> $profile
New-Alias np notepad.exe

function welcome{
# Lab 2 COMP2101 welcome script for profile
#

write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."

}


function get-cpuinfo {
    $outputdata = Get-CimInstance CIM_Processor | 
              Select-Object Manufacturer, Name, MaxClockSpeed, CurrentClockSpeed, NumberOfCores | 
              Format-List
    return $outputdata
}

function get-mydisks {
    $outputdata = Get-CimInstance CIM_DiskDrive | 
              Select-Object Manufacturer, Model, SerialNumber, FirmwareRevision, Size  | 
              Format-Table -AutoSize
    return $outputdata
}


#### Ip config file
 ### function sysIPCInfo will fetch Network configuration detail for my vmware..
function sysIPCInfo{
$Fetched = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}
$outputdata = foreach ($Fetch in $Fetched ) {
    [PSCustomObject]@{
        "description" = $Fetch.Description
        "index" = $Fetch.Index
        "ip address" = $Fetch.IPAddress
        "subnet mask" = $Fetch.IPSubnet
        "DNS domain name" = $Fetch.DNSDomain
        "DNS server" = $Fetch.DNSServerSearchOrder
        "default gateway" = $Fetch.DefaultIPGateway
        "DHCP server" = $Fetch.DHCPServer
    }
}
$outputdata | Format-Table -AutoSize

}

#sysIPCInfo


##system report file
### function sysHardwareInfo will fetch Hardware detail for my vmware..
function sysHardwareInfo{
    $Fetched = Get-CimInstance -ClassName Win32_ComputerSystem
    $total = [double]$Fetched.TotalPhysicalMemory / 1GB
    $Mtotal = "{0:N2}" -f $total
    
    $outputdata = [PSCustomObject]@{
        "manufacturer" = $Fetched.Manufacturer
        "model" = $Fetched.Model
        "total memory" = "$Mtotal GB (physical)"
        "description" =$Fetched.Description
        "type" = $Fetched.SystemType
    } 

    return $outputdata
}



### function sysoperating will fetch operating detail for my vmware..
function sysoperating {
    $Fetched = Get-WmiObject -Class Win32_OperatingSystem
    $outputdata=[PSCustomObject]@{
        "name" = $Fetched.Caption
        "version" = $Fetched.Version
    }
return $outputdata
}

### function sysprocessor will fetch processor detail for my vmware..
function sysprocessor {
   $Fetched = Get-WmiObject -Class Win32_Processor
    $outputdata = [ordered]@{
        "name" = $Fetched.Name
        "number of cores" = $Fetched.NumberOfCores
        "speed" = $Fetched.MaxClockSpeed
        "L1 cache size" = if ($Fetched.L1CacheSize) { ($Fetched.L1CacheSize[0] / 1KB).ToString("#.## KB") } else { "N/A" }
        "L2 cache size" = if ($Fetched.L2CacheSize) { ($Fetched.L2CacheSize[0] / 1KB).ToString("#.## KB") } else { "N/A" }
        "L3 cache size" = if ($Fetched.L3CacheSize) { ($Fetched.L3CacheSize[0] / 1KB).ToString("#.## KB") } else { "N/A" }

    }
    return $outputdata.GetEnumerator() | Format-List
    
}


### function sysmemInfo will fetch memory detail for my vmware..
function sysmemInfo {
   $Fetched = Get-WmiObject -Class Win32_PhysicalMemory
    $total = 0
    $outputdata = foreach ($Fetch in $Fetched) {
        [PSCustomObject]@{
            vendor = $Fetch.Manufacturer
            description = $Fetch.Description
            capacity = "{0:N2} GB" -f ($Fetch.Capacity / 1GB)
            slot = $Fetch.DeviceLocator
            type = $Fetch.MemoryType
            speed = $Fetch.Speed
        }
        $total += $Fetch.Capacity
    }
    
    
    $outputdata | Format-Table -AutoSize
    Write-Output "total : $(('{0:N2}' -f ($total / 1GB))) GB"
    Write-Output "   "

 }

### function sysdiskinfo will fetch disk drive detail for my vmware..
function sysdiskinfo{
 $diskdrives = CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                
        $outputdata= [PSCustomObject]@{

          manufacturer=$disk.Manufacturer
          model=$disk.Model     
          size = "{0:N2}" -f ($logicaldisk.Size / 1GB)
          "availableSpace" = "{0:N2}" -f ($logicaldisk.FreeSpace / 1GB)
          "freeSpace" = "[math]::Round(($logicaldisk.FreeSpace / $logicaldisk.Size) * 100, 2)%"
           
            }
         $outputdata
           }
      }
  }

}
                                                         
### function sysVCInfo will fetch video controller detail for my vmware..
function sysVCInfo {
    $Fetched = Get-WmiObject -Class Win32_VideoController
    $outputdata= foreach ($Fetch in $Fetched) {
        [PSCustomObject]@{
            vendor = $Fetch.VideoProcessor
            description = $Fetch.Description
            resolution = "{0}x{1}" -f $Fetch.CurrentHorizontalResolution, $Fetch.CurrentVerticalResolution
        }
    }
    $outputdata | Format-List
}



### This will fetch all the functions and displays on powershell
# calling all the function and display outputdata
Write-Output " 	"
Write-Output "*******************************************************************************************"
Write-Output "*******************************************************************************************"
Write-Output "                             `% System Information Report `%                         "
Write-Output "                              *****************************                           " 
Write-Output "*******************************************************************************************"
Write-Output "*******************************************************************************************"


Write-Output "Systems Hardware"
sysHardwareInfo | Format-List

Write-Output "Systems Oprating System"
sysoperating | Format-List


Write-Output "Systems Processor"
sysprocessor | Format-List


Write-Output "Systems RAM Memory"
sysmemInfo

Write-Output "Systems Disk Drive"
sysdiskinfo | Format-Table -AutoSize


Write-Output "Systems IP Configuration"
##./ipConfig.ps1
sysIPCInfo


Write-Output "Systems Video Controller"
sysVCInfo | Format-List



Write-Output "*******************************************************************************************"
Write-Output "*******************************************************************************************"

