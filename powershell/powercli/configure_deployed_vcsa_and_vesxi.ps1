# Configure already deployed vcsa + x3 vesxi with powercli
# Mattias Ukusic 2016

$vc="X"
$vc_user="administrator@vsphere.local"
$vc_user_pass="X"
$esxhosts=@("192.168.1.201", "192.168.1.202", "192.168.1.203")
$esxuser="root"
$esxpass="X"
$cluster="X"
$datacenter="X"
$VMKNetforVSAN = "Management Network"

#### DO NOT EDIT BELOW ####

# ignore cert warning
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false

# connect to vc
Try
{
    Connect-VIServer $vc -User $vc_user -Password $vc_user_pass -ea Stop | Out-Null
}
Catch
{
    Write-Host "[Error] Can not connect to vCenter Server: $vc, exit script"
    Exit
}

# create datacenter and cluster
$folder = Get-Folder -NoRecursion | Select -First 1
$NewDatacenter =  New-DataCenter -Name $datacenter -Location $folder
$NewCluster = New-Cluster -Name $cluster -Location $datacenter

Write-Host "Created Datacenter: $datacenter ..."
Write-Host "Created Cluster: $cluster ..."

# add hosts
$cluster_ref = Get-Cluster $cluster

foreach($esxhost in $esxhosts) {
    Write-Host "Adding $esxhost to $cluster ..."
    $AddedHost = Add-VMHost -Name $esxhost -Location $cluster_ref -User $esxuser -Password $esxpass -Force | out-null

    # Check to see if they have a VSAN enabled VMKernel
    $VMKernel = $AddedHost | Get-VMHostNetworkAdapter -VMKernel | Where {$_.PortGroupName -eq $VMKNetforVSAN }
    $IsVSANEnabled = $VMKernel | Where { $_.VsanTrafficEnabled}
    # If it isnt Enabled then Enable it
    If (-not $IsVSANEnabled) {
       Write-Host "Enabling VSAN Kernel on $VMKernel"
       $VMKernel | Set-VMHostNetworkAdapter -VsanTrafficEnabled $true -Confirm:$false | Out-Null
    } Else {
       Write-Host "VSAN Kernel already enabled on $VmKernel"
       $IsVSANEnabled | Select VMhost, DeviceName, IP, PortGroupName, VSANTrafficEnabled
    }
}

# Enable VSAN on the cluster and set to Automatic Disk Claim Mode
Write-Host "Enabling VSAN on $NewCluster"
$VSANCluster = $NewCluster | Set-Cluster -VsanEnabled:$true -VsanDiskClaimMode Automatic -Confirm:$false -ErrorAction SilentlyContinue
    If ($VSANCluster.VSANEnabled){
       Write-Host "VSAN cluster $($VSANCLuster.Name) created in $($VSANCluster.VSANDiskClaimMode) configuration"
       Write-Host "The following Hosts and Disk Groups now exist:"
       Get-VsanDiskGroup | Select VMHost, Name | FT -AutoSize
       Write-Host "The following VSAN Datastore now exists:"
       Get-Datastore | Where {$_.Type -eq "vsan"} | Select Name, Type, FreeSpaceGB, CapacityGB
} Else {
    Write-Host "Something went wrong, VSAN not enabled"
}

Write-Host "VSAN Ready! But does not get enabled automagiskt ..."

Try
{
    Disconnect-VIServer * -Force -Confirm:$False
}
Catch
{
    # Nothing to do - no open connections!
}
