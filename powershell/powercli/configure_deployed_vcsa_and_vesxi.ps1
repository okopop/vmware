# Configure already deployed vcsa + x3 vesxi with powercli
# Mattias Ukusic, 2016

$vc="X"
$vc_user="administrator@vsphere.local"
$vc_user_pass="X"
$esxhosts=@("192.168.1.201", "192.168.1.202", "192.168.1.203")
$esxuser="root"
$esxpass="X"
$cluster="X"
$datacenter="X"

#### DO NOT EDIT BELOW ####

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
New-DataCenter -Name $datacenter -Location $folder
New-Cluster -Name $cluster -Location $datacenter

Write-Host "Created Datacenter: $datacenter ..."
Write-Host "Created Cluster: $cluster ..."

# add hosts
$cluster_ref = Get-Cluster $cluster

$tasks = @()
foreach($esxhost in $esxhosts) {
    Write-Host "Adding $esxhost to $cluster ..."
    Add-VMHost -Name $esxhost -Location $cluster_ref -User $esxuser -Password $esxpass -Force | out-null
}

Write-Host "VSAN Ready! But does not get enabled automagiskt ..."

#$spec = New-Object VMware.Vim.ClusterConfigSpecEx
#$vsanconfig = New-Object VMware.Vim.VsanClusterConfigInfo
#$defaultconfig = New-Object VMware.Vim.VsanClusterConfigInfoHostDefaultInfo
#$defaultconfig.AutoClaimStorage = $false
#$vsanconfig.DefaultConfig = $defaultconfig
#$vsanconfig.enabled = $true
#$spec.VsanConfig = $vsanconfig

#Write-Host "Enabling VSAN Cluster on $cluster ..."
#$task = $cluster_ref.ExtensionData.ReconfigureComputeResource_Task($spec,$true)
#$task1 = Get-Task -Id ("Task-$($task.value)")
#$task1 | Wait-Task | out-null
#Write-Host "OBS: You need to claim disks, autoclaim dont work without License key!"

Try
{
    Disconnect-VIServer * -Force -Confirm:$False
}
Catch
{
    # Nothing to do - no open connections!
}
