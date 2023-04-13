
### function sysHardwareInfo will fetch Hardware detail for my vmware..
function sysHardwareInfo{
    $Fetched = Get-CimInstance -ClassName Win32_ComputerSystem
    $total = [double]$Fetched.TotalPhysicalMemory / 1GB
    $Mtotal = "{0:N2}" -f $total
    
    $outputdata = [PSCustomObject]@{
        "manufacturer" = if($Fetched.Manufacturer){ $Fetched.Manufacturer} else { "N/A"}
        "model" = if($Fetched.Model){ $Fetched.Model} else { "N/A"}
        "total memory" = if("$Mtotal"){ "$Mtotal GB (physical)"} else { "N/A"}
        "description" =if($Fetched.Description){ $Fetched.Description} else { "N/A"}
        "type" = if($Fetched.SystemType){ $Fetched.SystemType} else { "N/A"}
    } 

    return $outputdata
}



### function sysoperating will fetch operating detail for my vmware..
function sysoperating {
    $Fetched = Get-WmiObject -Class Win32_OperatingSystem
    $outputdata=[PSCustomObject]@{
        "name" = if($Fetched.Caption) {$Fetched.Caption} else { "N/A"}
        "version" = if($Fetched.Version) {$Fetched.Version} else { "N/A"}
    }
return $outputdata
}

### function sysprocessor will fetch processor detail for my vmware..
function sysprocessor {
   $Fetched = Get-WmiObject -Class Win32_Processor
    $outputdata = [ordered]@{
        "name" = if($Fetched.Name) {$Fetched.Name} else {"N/A"}
        "number of cores" = if($Fetched.NumberOfCores) {$Fetched.NumberOfCores} else {"N/A"}
        "speed" = if($Fetched.MaxClockSpeed) {$Fetched.MaxClockSpeed} else {"N/A"}
        "L1 cache size" = if(($Fetched.L1CacheSize[0] / 1KB).ToString("#.##")) { ($Fetched.L1CacheSize[0] / 1KB).ToString("#.## KB") } else { "N/A" }
        "L2 cache size" = if(($Fetched.L2CacheSize[0] / 1KB).ToString("#.##")) { ($Fetched.L2CacheSize[0] / 1KB).ToString("#.## KB") } else { "N/A" }
        "L3 cache size" = if(($Fetched.L3CacheSize[0] / 1KB).ToString("#.##")) { ($Fetched.L3CacheSize[0] / 1KB).ToString("#.## KB") } else { "N/A" }
	
    }
    return $outputdata.GetEnumerator() | Format-List
    
}


### function sysmemInfo will fetch memory detail for my vmware..
function sysmemInfo {
   $Fetched = Get-WmiObject -Class Win32_PhysicalMemory
    $total = 0
    $outputdata = foreach ($Fetch in $Fetched) {
        [PSCustomObject]@{
            vendor = if($Fetch.Manufacturer) {$Fetch.Manufacturer} else {"N/A"}
            description = if($Fetch.Description) {$Fetch.Description} else {"N/A"}
            "capacity-GB" = if("{0:N2}" -f ($Fetch.Capacity / 1GB)) {"{0:N2}" -f ($Fetch.Capacity / 1GB)} else {"N/A"}
            "Ram-slot" = if($Fetch.DeviceLocator) {$Fetch.DeviceLocator} else {"N/A"}
            type = if($Fetch.MemoryType) {$Fetch.MemoryType} else {"N/A"}
            speed = if($Fetch.Speed) {$Fetch.Speed} else {"N/A"}
        }
        $total += $Fetch.Capacity
    }
    
    
    $outputdata | Format-Table -AutoSize
    Write-Output "total Memory found in system: $(('{0:N2}' -f ($total / 1GB))) GB"
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
              $freeSpace = [math]::Round(($logicaldisk.FreeSpace / $logicaldisk.Size) * 100, 2)
            
            $outputdata= [PSCustomObject]@{

            manufacturer=if($disk.Manufacturer){$disk.Manufacturer} else {"N/A"}
            model=if($disk.Model){$disk.Model} else {"N/A"}     
            "Size(GB)" = if("{0:N2}" -f ($logicaldisk.Size / 1GB)) {"{0:N2}" -f ($logicaldisk.Size / 1GB)} else {"N/A"}
            "Free-Space(GB)" = if("{0:N2}" -f ($logicaldisk.FreeSpace / 1GB)) {"{0:N2}" -f ($logicaldisk.FreeSpace / 1GB)} else {"N/A"}
            "Free-space(%)" = if("$freeSpace") {"$freeSpace"} else {"N/A"}

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
            vendor = if($Fetch.VideoProcessor){$Fetch.VideoProcessor} else {"N/A"}
            description = if($Fetch.Description){$Fetch.Description} else {"N/A"}
            resolution = if("{0}x{1}" -f $Fetch.CurrentHorizontalResolution, $Fetch.CurrentVerticalResolution) {"{0}x{1}" -f $Fetch.CurrentHorizontalResolution, $Fetch.CurrentVerticalResolution} else {"N/A"}
        }
    }
    $outputdata | Format-List
}

### function sysIPCInfo will fetch Network configuration detail for my vmware..
function sysIPCInfo{
$Fetched = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}
$outputdata = foreach ($Fetch in $Fetched ) {
    [PSCustomObject]@{
        "description" = if($Fetch.Description){ $Fetch.Description } else {"N/A"}
        "index" = if($Fetch.Index){ $Fetch.Index} else {"N/A"}
        "ip address" = if($Fetch.IPAddress){$Fetch.IPAddress} else {"N/A"}
        "subnet mask" = if($Fetch.IPSubnet){ $Fetch.IPSubnet} else {"N/A"}
        "DNS domain name" = if($Fetch.DNSDomain){$Fetch.DNSDomain} else {"N/A"}
        "DNS server" = if($Fetch.DNSServerSearchOrder){$Fetch.DNSServerSearchOrder} else {"N/A"}
        "default gateway" = if($Fetch.DefaultIPGateway){$Fetch.DefaultIPGateway} else {"N/A"}
        "DHCP server" = if($Fetch.DHCPServer){$Fetch.DHCPServer} else {"N/A"}
    }
}
$outputdata | Format-Table -AutoSize

}



### This will fetch all the functions and displays on powershell
# calling all the function and display outputdata
$width = $Host.UI.RawUI.BufferSize.Width #store laptop width
$line = "_" * $width
$seperator = "-" * $width


Write-Output " 	"
Write-Output "$line"
Write-Output "$line"
Write-Output "                           				  `% System Information Report `%                         "
Write-Output "$line"
Write-Output "$line"


Write-Output "	Systems Hardware $seperator"
sysHardwareInfo | Format-List

Write-Output "	Systems Oprating System $seperator"
sysoperating | Format-List


Write-Output "	Systems Processor $seperator"
sysprocessor | Format-List


Write-Output "	Systems RAM Memory $seperator"
sysmemInfo

Write-Output "	Systems Disk Drive $seperator"
sysdiskinfo | Format-Table -AutoSize


Write-Output "	Systems IP Configuration $seperator"
sysIPCInfo

Write-Output "	Systems Video Controller $seperator"
sysVCInfo | Format-List

Write-Output "$line"
Write-Output "$line"
Write-Output "  "