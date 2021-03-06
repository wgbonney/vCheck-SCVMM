# Start of Settings
# Threshold for virtual machine age (days)
$VMCreationThreshold ="30"
# End of Settings

$Title = "New VMs"
$Header ="New VMs"
$Comments = "Virtual machines created during the last $VMCreationThreshold days"
$Display = "Table"
$Author = "Jan Egil Ring"
$PluginVersion = 1.0
$PluginCategory = "SC VMM"

switch -wildcard ($VMMServer.ProductVersion) 
    { 
        "2.*" {Get-Job -Name "Create virtual machine" -All | Where-Object {$_.StartTime -gt $date.AddDays(-$VMCreationThreshold) } | Select-Object @{Name="VM";Expression={$_.Resultname}},@{Name="VMHost";Expression={(Get-VM $_.Resultname -ea silentlycontinue).VMHost.Name}},owner,starttime,endtime,Status} 
        "3.*" {Get-SCJob -Name "Create virtual machine" -All | Where-Object {$_.StartTime -gt $date.AddDays(-$VMCreationThreshold) } | Select-Object @{Name="VM";Expression={$_.Resultname}},@{Name="VMHost";Expression={(Get-SCVirtualMachine $_.Resultname -ea silentlycontinue).VMHost.Name}},owner,starttime,endtime,Status} 
        default {break}
    }