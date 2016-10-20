#!/bin/bash

# exit on any error
set -e

# WP Web install
# Prereq - open up port 80 on network security group
# set inbound rule to allow tcp on all ports into port 80
# and 443 if you want ssl

echo "Welcome to prod_web_setup_script: Number of parameters was: " $#

# need to pass in the the DNC credentials
if [ $# -lt 15 ]; then
    echo $0: usage: prod_web_setup_script.sh [ClusterIP] [DnccDb] [DnccUser] [DnccUserPass] [IsRenderSite] [RenderSiteUrl] [ShareUrl] [ShareUser] [SharePass] [gitsshprivkey] [gitrepo] [gitbranch] [master] [localslavesarray] [remoteslavesarray][port] [sshuser] [sshprivatekey]
    echo "Number of parameters was: " $#

	exit 1
fi

echo "Welcome to the jungle ... we got fun ..."

clusterIp=$1
dnccDb=$2
dnccUser=$3
dnccUserPass=$4
isRenderSite=$5
renderSiteUrl=$6
shareUrl=$7
shareUser=$8
sharePass=$9
gitsshprivkey=${10}
gitrepo=${11}
gitbranch=${12}
master=${13}
localslaves=${14}
remoteslaves=${15}
port=${16}
sshuser=${17}
sshprivkey=${18}

chmod 777 ./setup_sshkey.sh
chmod 777 ./setup_hyperdb.sh


echo "Checking for apache2 already installed"
if dpkg -s apache2 > /dev/null 2>&1; then
     echo "Package installed already - exiting"
     exit
else
     echo "Package not installed - proceeding"
fi

# install needed bits in a loop because a lot of installs happen
# on VM init, so won't be able to grab the dpkg lock immediately
until apt-get -y update && apt-get -y install apache2 php5 php5-mysql php5-curl git
do
  echo "Try again"
  sleep 2
done

# turn off apache until we are done with setup
apachectl stop

echo "Configuring git connectivity for $gitrepo"
IFS='@' read gituser gitdomain <<< $gitrepo

echo "Registering git domain: $gitdomain"

echo "Web Setup Script V1.1"
echo "we are in (a yellow submarine)"
pwd

if [ ! -z "$gitsshprivkey" ]; then
. ./setup_sshkey.sh $gitsshprivkey $gitdomain $gituser
else
	echo "no SSH private key. Skipping setup"
fi 

# remove html dir so we can clone into it
rm -rf /var/www/html

echo "Attemtping git clone of dncc repo.."
git clone ssh://$gitrepo:22/_git/convention2016 --branch $gitbranch --single-branch /var/www

# Update wp-config and set up WP login
sed -i 's/database_name_here/'$dnccDb'/' /var/www/html/wp-config.php
sed -i 's/username_here/'$dnccUser'/' /var/www/html/wp-config.php
sed -i 's/password_here/'$dnccUserPass'/' /var/www/html/wp-config.php
sed -i 's/localhost/'$clusterIp:$port'/' /var/www/html/wp-config.php

# update cache dir owner for super cache and feeds
chown www-data /var/www/html/wp-content/cache
chown www-data /var/www/html/wp-content/themes/wideeyecreative/includes/features/grabfeeds/includes

#enable mod_rewrite and headers
a2enmod rewrite
a2enmod headers
a2enmod expires

#need to allow override in apache2.conf for /var/www
#when this is done the directory section for /var/www should look like so:
#<Directory /var/www/>
#        Options Indexes FollowSymLinks
#        AllowOverride All
#       Require all granted
#</Directory>
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Hide server version
echo "ServerSignature Off" >> /etc/apache2/apache2.conf
echo "ServerTokens Prod" >> /etc/apache2/apache2.conf
sed -i 's/expose_php = On/expose_php = Off/' /etc/php5/apache2/php.ini

# to set up ssl (need to set up certificate)
a2enmod ssl
a2ensite default-ssl

#edit apache config
sslthumb='C43CF141EB30A7A3C1FF34457AF2C6FC82145905'
sslchainthumb='1FB86B1168EC743154062E8C9CC5B171A4B7CCB4'

sslcertfilename=$sslthumb'.crt'
sslkeyfilename=$sslthumb'.prv'
sslcafilename=$sslchainthumb'.crt'

echo "Copying SSL certs"
cp /var/lib/waagent/$sslcafilename /etc/ssl/certs/
cp /var/lib/waagent/$sslcertfilename /etc/ssl/certs/
cp /var/lib/waagent/$sslkeyfilename /etc/ssl/private/

echo "configuring certfile"
sed -i 's/#*SSLCertificateFile.*$/SSLCertificateFile \/etc\/ssl\/certs\/'$sslcertfilename'/g' /etc/apache2/sites-enabled/default-ssl.conf
echo "keyfile"
sed -i 's/#*SSLCertificateKeyFile.*$/SSLCertificateKeyFile \/etc\/ssl\/private\/'$sslkeyfilename'/g' /etc/apache2/sites-enabled/default-ssl.conf
echo "chain cert"
sed -i 's/#*SSLCertificateChainFile.*$/SSLCertificateChainFile \/etc\/ssl\/certs\/'$sslcafilename'/g' /etc/apache2/sites-enabled/default-ssl.conf

# default for uploads is readonly unless we are on authorsite
uploadsMods=0555
uploadMountLocation="/var/www/uploadshare"

if [ $isRenderSite = "1" ]; then
     echo "Setting render site settings"
     rm -rf /var/www/html/wp-admin
     rm /var/www/html/wp-login.php
     # hardcode site to URL of LB by inserting at line 35 & 36 of wp-config
     sed -i "35i define('WP_HOME','$renderSiteUrl');" /var/www/html/wp-config.php
     sed -i "36i define('WP_SITEURL','$renderSiteUrl');" /var/www/html/wp-config.php
     rsync -uir --delete /var/www/uploadshare/. /var/www/html/wp-content/uploads/
     echo '*/1 * * * * rsync -uir --delete /var/www/uploadshare/. /var/www/html/wp-content/uploads/ >> /var/log/cronjobr.log 2>&1' >> /tmp/tmp_gitcron
elif [ $isRenderSite = "2" ]; then

	echo "Registering file share for" $master $sshuser
	echo "with " $sshprivkey
	if [ ! -z "$sshprivkey" ]; then
	. ./setup_sshkey.sh "$sshprivkey" $master $sshuser
	else
		echo "no SSH private key. Skipping setup"
	fi 

     echo "Secondary Setting render site settings"
     rm -rf /var/www/html/wp-admin
     rm /var/www/html/wp-login.php
     # hardcode site to URL of LB by inserting at line 35 & 36 of wp-config
     sed -i "35i define('WP_HOME','$renderSiteUrl');" /var/www/html/wp-config.php
     sed -i "36i define('WP_SITEURL','$renderSiteUrl');" /var/www/html/wp-config.php
     rsync -uir --delete $master:/var/www/uploadshare/. /var/www/html/wp-content/uploads/
     echo '*/1 * * * * rsync -uir --delete $master:/var/www/uploadshare/. /var/www/html/wp-content/uploads/ >> /var/log/cronjobr.log 2>&1' >> /tmp/tmp_gitcron
else
	echo "configuring file share on authoring site" 
     # author site will point to render site for ALL content - thus URL needs to be https and not end in a slash
     sed -i "35i define('WP_CONTENT_URL','$renderSiteUrl/wp-content');" /var/www/html/wp-config.php
     # read/write for uploads
     uploadsMods=0777
     uploadMountLocation="/var/www/html/wp-content/uploads"
fi

echo "preparing log location..."
mkdir -p /var/log/apache2/logship


#dont mount on secondaries
if [ $isRenderSite != "2" ]; then
	# set the share credentials
	echo "username=$shareUser" > /usr/local/etc/.dncsharecreds
	echo "password=$sharePass" >> /usr/local/etc/.dncsharecreds

	echo "username=dncweblogs" > /usr/local/etc/.dnclogsharecreds
	echo "password=4byrjo4O0y8CZuiW6FG3mvrr/BA29zFBdClAl7qkJ2+kxg45EhDEBufv7FiCJ47HhrgtS4EOqnnVB2rlUWFCdw==" >> /usr/local/etc/.dnclogsharecreds
	echo "//dncweblogs.file.core.windows.net/prod-apache /var/log/apache2/logship cifs vers=3.0,uid=www-data,credentials=/usr/local/etc/.dnclogsharecreds,dir_mode=0777,file_mode=0777" >> /etc/fstab

	# Add the uploads share to fstab
	echo "$shareUrl $uploadMountLocation cifs vers=3.0,uid=www-data,credentials=/usr/local/etc/.dncsharecreds,dir_mode=${uploadsMods},file_mode=${uploadsMods}" >> /etc/fstab
	echo "Mounting share"
	mount -a
fi 
#config hyperdb

echo "Setting up HyperDB"
. ./setup_hyperdb.sh $dnccDb $dnccUser $dnccUserPass $master $localslaves $remoteslaves $port

echo "final prep on git"

# Do a git checkin so we can merge any future changes
cd /var/www
git add html/wp-config.php 
git commit -m "another local commit so we can do a pull"

echo "configurng cron for code updates from git"
#Configure cronjob to perform git pull every 10 minutes
echo '*/10 * * * * echo $(date) >> /var/log/cronjob.log && cd /var/www && git pull >> /var/log/cronjob.log 2>&1' >> /tmp/tmp_gitcron
echo "configurng cron for cache invalidtion"

echo 'creating cache cleanup cron'
echo '*/5 * * * * echo "Clear Cache" $(date) >> /var/log/cronjobc.log && find /var/www/html/wp-content/cache/ -type f -delete  2>&1' >> /tmp/tmp_gitcron
echo 'creating logrotate cron'
echo '1 * * * *  /usr/sbin/logrotate -f /etc/logrotate.d/apache2' >> /tmp/tmp_gitcron
echo 'creating cache logship crons'
echo '3 * * * * mkdir -p /var/log/apache2/logship/$(date +\%Y)/$(date +\%m)/$(date +\%d) && cp /var/log/apache2/access.log.1 /var/log/apache2/logship/$(date +\%Y)/$(date +\%m)/$(date +\%d)/prodrender_'$(hostname)'_$(date +\%Y_\%m_\%d_\%H).access.log' >> /tmp/tmp_gitcron
echo '4 * * * * mkdir -p /var/log/apache2/logship/$(date +\%Y)/$(date +\%m)/$(date +\%d) && cp /var/log/apache2/error.log.1 /var/log/apache2/logship/$(date +\%Y)/$(date +\%m)/$(date +\%d)/prodrender_'$(hostname)'_$(date +\%Y_\%m_\%d_\%H).error.log' >> /tmp/tmp_gitcron

echo 'Writing to crontab'
crontab /tmp/tmp_gitcron
rm /tmp/tmp_gitcron 

echo "restarting apache"
# all done - turn apache on
apachectl start

echo "Done!"
