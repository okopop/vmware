
# Deploy x3 esxi ova to esxi with ovftool
# By Mattias Ukusic 2016, creds to William Lam, virtuallyghetto.com

$OVFTOOL_PATH="C:\Program Files\VMware\VMware OVF Tool\ovftool.exe"
$ESXI_OVA="E:\Nested_ESXi6.x_Appliance_Template_v5.ova"

$ESXI_HOST="X"
$ESXI_USERNAME="root"
$ESXI_PASSWORD="X"

$VM_NAME = "X"
$DATASTORE="X"
$VM_NETWORK="VM Network"
$IP_RANGE="192.168.1"
$VM_NAME_PREFIX = 1

$gi_netmask = "255.255.255.0"
$gi_gateway = "192.168.1.1"
$gi_dns = "192.168.1.1"
$gi_domain = "X"
$gi_ntp = "192.168.1.1"
$gi_ssh = "True"
$gi_password = "X"
$gi_createvmfs = "False"
$gi_syslog = ""

### DO NOT EDIT BEYOND HERE ###

201..203 | Foreach {

    $ipaddress = "$IP_RANGE.$_"
    $VM_NAME += "$VM_NAME_PREFIX"

& $OVFTOOL_PATH `
--name=$VM_NAME `
--X:injectOvfEnv `
--acceptAllEulas `
--noSSLVerify `
--allowExtraConfig `
--net:'VM Network='$VM_NETWORK `
--diskMode=thin `
--overwrite `
--skipManifestCheck `
--X:enableHiddenProperties `
--datastore=$DATASTORE `
--prop:guestinfo.hostname=$VM_NAME `
--prop:guestinfo.ipaddress=$ipaddress `
--prop:guestinfo.netmask=$gi_netmask `
--prop:guestinfo.gateway=$gi_gateway `
--prop:guestinfo.dns=$gi_dns `
--prop:guestinfo.domain=$gi_domain `
--prop:guestinfo.ntp=$gi_ntp `
--prop:guestinfo.ssh=$gi_ssh `
--prop:guestinfo.password=$gi_password `
--prop:guestinfo.createvmfs=$gi_createvmfs `
--prop:guestinfo.syslog=$gi_syslog `
--powerOn `
$ESXI_OVA `
vi://${ESXI_USERNAME}:${ESXI_PASSWORD}@${ESXI_HOST}

$VM_NAME_PREFIX++
}
