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

sysIPCInfo