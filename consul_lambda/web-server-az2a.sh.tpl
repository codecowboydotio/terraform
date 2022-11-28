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
apt install -y apache2
systemctl start apache2
git clone https://github.com/platzhersh/pacman-canvas /var/www/html/
mv /var/www/html/index.htm /var/www/html/index.html
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
echo "updated sources"
sudo apt update 
sudo apt install -y consul

mkdir -p /etc/consul.d
mkdir -p /var/log/consul
echo "consul agent -config-dir=/etc/consul.d -log-file=/var/log/consul/consul.log -data-dir=/tmp -retry-join ${consul_address}" > /root/consul.sh
chmod 755 /root/consul.sh
rm -rf /var/www/html/index*
git clone https://github.com/platzhersh/pacman-canvas /var/www/html/
mv /var/www/html/index.htm /var/www/html/index.html
cat << EOF > /etc/consul.d/web.json
{
  "service": {
    "name": "web",
    "tags": [
      "webapp"
    ],
    "port": 80,
    "meta": {
      "service_port": "80",
      "service_type": "http"
    },
    "check": {
      "id": "service_check",
      "name": "Check httpd health",
      "service_id": "web_1",
      "http": "http://localhost/",
      "method": "GET",
      "interval": "10s",
      "timeout": "1s"
    }
  }
}
EOF
nohup /root/consul.sh &
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
