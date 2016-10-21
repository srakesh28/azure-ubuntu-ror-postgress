
Create Resource Group

azure group create demo1 westus

Deploy Network Subnets : azure.network.json – sets up the network and NSGs between the subnets.

Azure CLI: azure group deployment create --template-uri https://raw.githubusercontent.com/srakesh28/azure-ubuntu-ror-postgress/master/azure.network.json  demo1

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.network.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>

</a>

Deploy Jump VMS: azure.jumpcluste.json - Deploy JumpServers 

Azure CLI azure group deployment create --template-uri https://raw.githubusercontent.com/srakesh28/azure-ubuntu-ror-postgress/master/azure.jumpcluster.json demo1

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.jumpcluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>


Deploy DB VMs : azure.dbcluster.json – Deploys Postgress master/slave cluster in DB Subnet,  Runs install_postgresql.sh on each VM using custom script extension to install postgress and configure replication.

Azure CLI : azure group deployment create --template-uri https://raw.githubusercontent.com/srakesh28/azure-ubuntu-ror-postgress/master/azure.dbcluster.json demo1

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.dbcluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>


Deploy Web Tier ROR VMs: azure.webcluster.json – Deploys ROR Web VMS in DMZ Subnet and  Runs install_ror.sh on each VM using custom script extension to install Ruby on Rails

Azure CLI : azure group deployment create --template-uri https://raw.githubusercontent.com/srakesh28/azure-ubuntu-ror-postgress/master/azure.webcluster.json demo1


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.webcluster.json" target="_blank">
<img src="http://azuredeploy.net/deploybutton.png"/>

Deploy Sidekiq VMs: azure.sidekiqcluster.json - Deploys Sideq servers in DMZ Subnet and runs install_sidekiq.sh on each vm

Azure CLI: azure group deployment create --template-uri https://raw.githubusercontent.com/srakesh28/azure-ubuntu-ror-postgress/master/azure.sidekiqcluster.json demo1

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsrakesh28%2Fazure-ubuntu-ror-postgress%2Fmaster%2Fazure.sidekiqcluster.json" target="_blank">

    <img src="http://azuredeploy.net/deploybutton.png"/>

</a>
