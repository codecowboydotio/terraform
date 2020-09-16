#!/bin/bash

: '
Copyright 2019 F5 Networks Inc.
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
'

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
sleep 50
logger -p local0.info 'firstrun debug: starting--config'
dnf -y install httpd
dnf -y install unzip
dnf -y install net-tools
systemctl start httpd
curl https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip -o /root/consul_1.8.3_linux_amd64.zip
unzip /root/consul_1.8.3_linux_amd64.zip -d /root/
mkdir -p /etc/consul.d
echo "./consul agent -config-dir=/etc/consul.d -data-dir=/tmp -join ${consul_address}" > /root/consul.sh
chmod 755 /root/consul.sh
git clone https://github.com/platzhersh/pacman-canvas /var/www/html/
mv /var/www/html/index.htm /var/www/html/index.html
cat << EOF > /etc/consul.d/web.json
{
  "service": {
    "name": "web",
    "tags": [
      "webapp"
    ],
    "port": 80
  }
}
EOF
logger -p local0.info 'firstrun debug: finished-config'
