# ignore cert
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false

# connect to vcsa
$vcsa_ip = ""
$vcsa_user = ""
$vcsa_pass = ""
Connect-VIServer -server $vcsa_ip -user $vcsa_user -password $vcsa_pass
