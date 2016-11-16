# Backup vds config
# Mattias Ukusic 2016

#### DONT EDIT BELOW

# variables
$vc = "<enter vc>"
$date = Get-Date -Format "yyy-MM-dd"
$backup_dest = "<enter backup dest>\$date"

# Connect to vcenter server
Connect-VIServer $vc | Out-Null
Write-Host "[Status] Backing up switches at vCenter Server: $vc"
Write-Host "[Status] Backup destination: $backup_dest"

# get all vds in vcenter server
$all_vds_in_cluster = Get-VDSwitch

# loop on vds found in vcenter server
foreach ($vds in $all_vds_in_cluster) {
Write-Host "[Status] Backing up config for vSphere Distributed Switch (vDS): $vds"
$vds | Export-VDSwitch -Server $vc -Force -Description "Backup vDS" -Destination "$backup_dest\$vds-$date.zip" | Out-Null
}
Write-Host "[Status] Backup of vds in $vc is complete"

Try
{
    Disconnect-VIServer * -Force -Confirm:$False
}
Catch
{
    # Nothing to do - no open connections!
}
