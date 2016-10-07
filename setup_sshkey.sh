#!/bin/bash

# exit on any error
set -e

# WP Web install
# Prereq - open up port 80 on network security group
# set inbound rule to allow tcp on all ports into port 80
# and 443 if you want ssl

echo "setup_sshkey says Hey Handsome"
echo "Number of parameters was: " $#

# need to pass in the the DNC credentials
if [ $# -ne 3 ]; then
    echo $0: usage: setup_sshkey.sh [SSHPrivKey] [host] [user]
    echo "Number of parameters was: " $#
	exit 1
fi

setupkey_key=${1}
setupkey_host=${2}
setupkey_user=${3}

setupkey_key=$(echo $setupkey_key | base64 --decode);

setupkey_keyfile=~/.ssh/${setupkey_host}.key

echo "Creating ssh key file.."
cat > "/tmp/tmp_key" << EOF
$setupkey_key
EOF

cat >> ~/.ssh/config << EOF
Host $setupkey_host
	HostName $setupkey_host
	User $setupkey_user
	IdentityFile $setupkey_keyfile
EOF

# Generate the final ssh private key from the keyvault and place in root user context
cp /tmp/tmp_key $setupkey_keyfile

# Add the git domain to known_hosts file for root
ssh-keyscan $setupkey_host >> ~/.ssh/known_hosts

chmod 400 $setupkey_keyfile

#remove the tmp key in /tmp/tmp_key
rm /tmp/tmp_key
