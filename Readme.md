#	azure.network.json – sets up the network and NSGs between the subnets.
#	azure.dbcluster.json – Postgress master/slave cluster. Runs install_postgresql.sh on each VM using custom script extension to install postgress and configure replication.

Scripts need to be uploaded to github or Azure Blob Storage or another publicly accessible site.

# Deploy Network Subnets etc
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.network.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>

</a>

# Deploy DB VMs etc
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.dbcluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
      

</a>
