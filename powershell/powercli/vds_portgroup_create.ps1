# Add vds portgroup 
# Mattias Ukusic 2016

#### DONT EDIT BELOW

Write-Host "This script will create one vDS portgroup"
Write-Host ""

# variables
$vc = Read-Host "Enter vCenter Server FQDN"

# Connect to vcenter server
Try
{
    Connect-VIServer $vc -ea Stop | Out-Null
}
Catch
{
    Write-Host "[Error] Can not connect to vCenter Server: $vc, exit script"
    Exit
}

Write-Host "---------------------------------"
Write-Host "Connected to vCenter Server: $vc"
Write-Host "---------------------------------"

# list all portgroups first
Get-Datacenter | Get-VDSwitch

Write-Host "---------------------------------"
$vds = Read-Host "Enter vds to add portgroup to"
Write-Host "---------------------------------"
$portgroup = Read-Host "Enter portgroup name to add"
$vlanid = Read-Host "Enter vlan-id"

if(!$vlanid) { Write-Host "[Error] Vlan-id not set"; Exit }

# create portgroup
Try
{
    Get-VDSwitch -Name $vds -ea Stop | New-VDPortgroup -Server $vc -Name $portgroup -PortBinding Static -NumPorts 256 -VlanId $vlanid
}
Catch
{
    Write-Host "[Error] Can not create portgroup: $portgroup on vDS: $vds, exit script"
    Disconnect-VIServer * -Force -Confirm:$False
    Exit
}


# set load balance on nic load
Get-VDPortgroup $portgroup | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -LoadBalancingPolicy LoadBalanceLoadBased

Write-Host "---------------------------------------------------------"
Write-Host "OBS: Dont forget to check vDS Healtch Check in vSphere Client"
Write-Host "---------------------------------------------------------"

Try
{
    Disconnect-VIServer * -Force -Confirm:$False
}
Catch
{
    # Nothing to do - no open connections!
}
