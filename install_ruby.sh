#!/bin/bash

# You must be root to run this script
if [ "${UID}" -ne 0 ];
then
    log "Script executed without root permissions"
    echo "You must be root to run this program." >&2
    exit 3
fi

# uncomment this if you want to use data disk 
# download file to format data disk

# wget https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/shared_scripts/ubuntu/vm-disk-utils-0.1.sh
# sudo chmod a+x vm-disk-utils-0.1.sh

#Format the data disk
#bash vm-disk-utils-0.1.sh -s
# data disk setup ends here

# TEMP FIX - Re-evaluate and remove when possible
# This is an interim fix for hostname resolution in current VM (If it does not exist add it)
grep -q "${HOSTNAME}" /etc/hosts
if [ $? == 0 ];
then
  echo "${HOSTNAME}found in /etc/hosts"
else
  echo "${HOSTNAME} not found in /etc/hosts"
  # Append it to the hsots file if not there
  echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts
fi

# Get today's date into YYYYMMDD format
now=$(date +"%Y%m%d")

install_ruby_service() {
	logger "Start installing Ruby and Rails packages..."
	# Re-synchronize the package index files from their sources. An update should always be performed before an upgrade.
	apt-get -y update

	# Install Ruby if it is not yet installed
	if [ $(dpkg-query -W -f='${Status}' ruby 2>/dev/null | grep -c "ok installed") -eq 0 ];
	then
	 
      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	 \curl -sSL https://get.rvm.io | bash -s stable --rails
	 rvm install 2.1.5
	fi
	
	logger "Done installing Ruby and Rails ..."
}

# MAIN ROUTINE
install_ruby_service
