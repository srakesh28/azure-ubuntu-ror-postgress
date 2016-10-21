

Scripts need to be uploaded to github or Azure Blob Storage or another publicly accessible site.

# Deploy Network Subnets : azure.network.json – sets up the network and NSGs between the subnets.
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.network.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>

</a>

# Deploy DB VMs : azure.dbcluster.json – Deploys Postgress master/slave cluster in DB Subnet,  Runs install_postgresql.sh on each VM using custom script extension to install postgress and configure replication.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.dbcluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
    
    
# Deploy Web Tier ROR VMs: azure.webcluster.json – Deploys ROR Web VMS in DMZ Subnet and  Runs install_ror.sh on each VM using custom script extension to install Ruby on Rails 

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.webcluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>

</a>
