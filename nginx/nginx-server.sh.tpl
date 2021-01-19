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
mkdir /etc/ssl/nginx
mv /tmp/nginx-repo* /etc/ssl/nginx
sudo wget https://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt-get install apt-transport-https lsb-release ca-certificates
printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
sudo wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx
sudo apt-get update
sudo apt-get install -y nginx-plus
cat << EOF > /etc/nginx/nginx.conf
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {

        log_format  main  '\$remote_addr [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" "\$http_user_agent"';

        upstream api_server {
            server ${SERVER_IP};
        }

        server {
            listen 80;

            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';

            location / {
                  proxy_pass http://api_server;
            }
        }
}
EOF
nginx
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
