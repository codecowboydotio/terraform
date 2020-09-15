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
%{ for pkg in linux_server_pkgs ~}
dnf -y install ${pkg}
%{ endfor ~}
curl https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip -o /root/consul_1.8.3_linux_amd64.zip
unzip /root/consul_1.8.3_linux_amd64.zip -d /root/
mkdir -p /etc/consul.d
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
  "ui": true
}
EOF
cat << EOF > /root/consul.sh
./consul agent -config-dir=/etc/consul.d
EOF
chmod 755 /root/consul.sh
logger -p local0.info 'firstrun debug: finished-config'
