•	azure.ror.vms – ROR farm based on VMs in Availability Sets. Runs prod_web2_setup_script.sh on each VM using custom script extension
•	azure.ror.vmss – ROR farm based on VMSS. Runs prod_web2_setup_script.sh on each VM using custom script extension
•	azure.dbcluster.json – Postgress master/slave cluster. Runs xtoph_db_set_script.sh to configure replication
•	azure.network.json – sets up the network and NSGs between the subnets.

web setup scripts configure SSL, HyperDb plugin to access the mariadb cluster and pull content from a git repository.

Scripts need to be uploaded to an Azure storage account or another publicly accessible site.

