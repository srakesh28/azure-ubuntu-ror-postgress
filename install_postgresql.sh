#!/bin/bash


# You must be root to run this script
if [ "${UID}" -ne 0 ];
then
    log "Script executed without root permissions"
    echo "You must be root to run this program." >&2
    exit 3
fi
# download file to format disk
wget https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/shared_scripts/ubuntu/vm-disk-utils-0.1.sh
sudo chmod a+x vm-disk-utils-0.1.sh

#Format the data disk
bash vm-disk-utils-0.1.sh -s
apt-get -y update
apt-get -y install postgresql=9.3* postgresql-contrib=9.3* postgresql-client=9.3*
