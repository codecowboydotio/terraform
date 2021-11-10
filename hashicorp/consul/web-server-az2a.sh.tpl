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
echo "firstrun debug: starting-config"
logger -p local0.info 'firstrun debug: starting--config'
%{ for pkg in linux_server_pkgs ~}
dnf -y install ${pkg}
%{ endfor ~}
sudo dnf install -y dnf-plugins-core
curl https://releases.hashicorp.com/consul/1.10.3/consul_1.10.3_linux_amd64.zip -o /root/consul_1.10.3_linux_amd64.zip
unzip /root/consul_1.10.3_linux_amd64.zip -d /root/
cp -p /root/consul /usr/bin
mkdir -p /etc/consul.d
mkdir -p /var/log/consul
curl https://raw.githubusercontent.com/codecowboydotio/terraform/main/consul_demo/files/consul.service -o /usr/lib/systemd/system/consul.service
cat << EOF > /etc/consul.d/consul.json
{
  "bootstrap": true,
  "server": true,
  "datacenter": "dc1",
  "data_dir": "/var/consul",
  "log_level": "INFO",
  "node_name": "server-node",
  "client_addr": "0.0.0.0",
  "bind_addr": "0.0.0.0",
  "bootstrap_expect": 1,
  "ui": true,
  "log_file": "/var/log/consul/consul.log"
}
EOF
systemctl start consul

echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
