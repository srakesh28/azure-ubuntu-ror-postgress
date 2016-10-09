•	azure.network.json – sets up the network and NSGs between the subnets.
•	azure.dbcluster.json – Postgress master/slave cluster. Runs xtoph_db_set_script.sh to configure replication
•	azure.ror.vms – ROR farm based on VMs in Availability Sets. Runs prod_web2_setup_script.sh on each VM using custom script extension



web setup scripts configure SSL, HyperDb plugin to access the mariadb cluster and pull content from a git repository.

Scripts need to be uploaded to an Azure storage account or another publicly accessible site.

# Deploy Network Subnets etc
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.network.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>

</a>

