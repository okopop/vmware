# Deploy vcsa to esxi with ovftool
# By Mattias Ukusic 2016, creds to William Lam, virtuallyghetto.com

$OVFTOOL_PATH="C:\Program Files\VMware\VMware OVF Tool\ovftool.exe"
$ESXI_OVA="E:\X\vmware-vcsa-65.ova"

$ESXI_HOST="X"
$ESXI_USERNAME="X"
$ESXI_PASSWORD="X"

$VM_NAME="vcsa65"
$DATASTORE="X"
$VM_NETWORK="VM Network"

$DEPLOYMENT_TYPE="embedded"
$NET_MODE="static"
$NET_FAMILY="ipv4"
$NET_PREFIX="24"
$NET_ADDRESS="X"
$NET_GATEWAY="X"
$NET_DNS="X"
$ROOT_PASS="X"
$NET_NTP="pool.ntp.org"
$SITE_NAME="X"
$DOMAIN_NAME="X"
$SSH_ENABLED="True"

### DO NOT EDIT BEYOND HERE ###

& $OVFTOOL_PATH `
--name=$VM_NAME `
--X:injectOvfEnv `
--acceptAllEulas `
--noSSLVerify `
--allowExtraConfig `
--net:'Network 1='$VM_NETWORK `
--diskMode=thin `
--overwrite `
--skipManifestCheck `
--X:enableHiddenProperties `
--datastore=$DATASTORE `
--powerOn `
--prop:guestinfo.cis.deployment.node.type=$DEPLOYMENT_TYPE `
--prop:guestinfo.cis.appliance.net.mode=$NET_MODE `
--prop:guestinfo.cis.appliance.net.addr.family=$NET_FAMILY `
--prop:guestinfo.cis.appliance.net.addr=$NET_ADDRESS `
--prop:guestinfo.cis.appliance.net.pnid=$NET_ADDRESS `
--prop:guestinfo.cis.appliance.net.prefix=$NET_PREFIX `
--prop:guestinfo.cis.appliance.net.gateway=$NET_GATEWAY `
--prop:guestinfo.cis.appliance.net.dns.servers=$NET_DNS `
--prop:guestinfo.cis.appliance.root.passwd=$ROOT_PASS `
--prop:guestinfo.cis.appliance.ssh.enabled=$SSH_ENABLED `
--prop:guestinfo.cis.deployment.autoconfig="True" `
--prop:guestinfo.cis.appliance.ntp.servers=$NET_NTP `
--prop:guestinfo.cis.vmdir.password=$ROOT_PASS `
--prop:guestinfo.cis.vmdir.site-name=$SITE_NAME `
--prop:guestinfo.cis.vmdir.domain-name=$DOMAIN_NAME `
--prop:guestinfo.cis.ceip_enabled="False" `
$ESXI_OVA `
vi://${ESXI_USERNAME}:${ESXI_PASSWORD}@${ESXI_HOST}
