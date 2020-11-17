#!/bin/bash

FILE=/tmp/firstrun.log
if [ ! -e $FILE ]
then
 touch $FILE
 nohup $0 0<&- &>/dev/null &
 exit
fi

exec 1<&-
exec 2<&-
exec 1<>$FILE
exec 2>&1
echo "firstrun debug: starting-config"
logger -p local0.info 'firstrun debug: starting--config'
logger -p local0.info 'firstrun debug: making directory for NGINX certificates'
echo "firstrun debug: making directory for NGINX certificates"
mkdir /etc/ssl/nginx
logger -p local0.info 'firstrun debug: moving NGINX certificates to directory'
echo "firstrun debug: moving NGINX certificates to directory"
mv /tmp/nginx-repo* /etc/ssl/nginx 
logger -p local0.info 'installing transport and cert util packages'
echo "installing transport and cert util packages"
sudo apt-get -y install apt-transport-https lsb-release ca-certificates wget
logger -p local0.info 'adding NGINX signing key'
echo "adding NGINX signing key"
sudo wget https://cs.nginx.com/static/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
logger -p local0.info 'adding NGINX repository for this OS'
echo "adding NGINX repository for this OS"
printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
logger -p local0.info 'adding NGINX startup files'
echo "adding NGINX startup files"
sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx
logger -p local0.info 'refreshing repository data'
echo "refreshing repository data"
sudo apt-get update
logger -p local0.info 'installing NGINX plus'
echo "installing NGINX plus"
sudo apt-get -y install nginx-plus
logger -p local0.info 'installing NGINX app protect'
echo "installing NGINX app protect"
sudo apt-get -y install app-protect
logger -p local0.info 'updating nginx config file'
echo "updating nginx config file"
WEB_IP=$(cat /tmp/web_internal_ip.txt)
echo $WEB_IP
sed -i "s/SERVER_IP/$WEB_IP/" /tmp/nginx.conf
mv /tmp/nginx.conf /etc/nginx
touch /var/log/nginx/security.log
chown nginx:adm /var/log/nginx/security.log
mv /tmp/log_default.json /etc/app_protect/conf
systemctl start nginx
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
