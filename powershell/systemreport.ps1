param ([switch]$System, [switch]$Disks, [switch]$Network)

$line = "_" * 1	40
$seperator = "-" * 140

if ($System) {
### This will fetch all the functions and displays on powershell
# calling all the function and display outputdata

Write-Output " 	"
Write-Output "$line"
Write-Output "                           				  `% System Information Report `%                         "
Write-Output "$line"

Write-Output "	Systems Hardware $seperator"
sysHardwareInfo | Format-List

Write-Output "	Systems Oprating System $seperator"
sysoperating | Format-List


Write-Output "	Systems Processor $seperator"
sysprocessor | Format-List


Write-Output "	Systems RAM Memory $seperator"
sysmemInfo


Write-Output "	Systems Video Controller $seperator"
sysVCInfo | Format-List

Write-Output "$line"
Write-Output "  "

}

elseif ($Disks) {
Write-Output "                           				  `% System Disks Information Report `%                         "

Write-Output "	Systems Disk Drive"
sysdiskinfo | Format-Table -AutoSize

}

elseif ($Network) {

Write-Output "                           				  `% Network Information Report `%                         "
Write-Output "	Systems IP Configuration"
sysIPCInfo

}

else{
### This will fetch all the functions and displays on powershell

Write-Output " 	"
Write-Output "$line"
Write-Output "                           				  `% System Information Report `%                         "
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
}
