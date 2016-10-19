#!/bin/bash
# set up a silent install of MySQL
dbpass="mySQLPassw0rd"

export DEBIAN_FRONTEND=noninteractive

sudo echo mysql-server-5.5 mysql-server/root_password password $dbpass | debconf-set-selections
sudo echo mysql-server-5.5 mysql-server/root_password_again password $dbpass | debconf-set-selections

# install the Apache

sudo apt-get -y install apache2

#wget https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/shared_scripts/ubuntu/vm-disk-utils-0.1.sh
#sudo chnmod a+x vm-disk-utils-0.1.sh

#Format the data disk
#bash vm-disk-utils-0.1.sh -s

# restart Apache
sudo apachectl restart
