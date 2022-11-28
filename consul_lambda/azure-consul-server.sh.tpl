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

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul

mkdir /var/log/consul
cat << EOF > /usr/lib/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/server.hcl

[Service]
Type=exec
User=root
Group=root
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/bin/consul reload
ExecStop=/usr/bin/consul leave
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /etc/consul.d/server.hcl
bootstrap = true
server = true
datacenter = "azuredc"
data_dir = "/var/consul"
log_level = "INFO"
node_name = "server-node"
client_addr = "0.0.0.0"
bind_addr = "0.0.0.0"
bootstrap_expect = 1
ui = true
log_file = "/var/log/consul/consul.log"
connect = {
  enabled = true
  enable_mesh_gateway_wan_federation = true
  enable_serverless_plugin = true
}
EOF
systemctl start consul.service
echo "firstrun debug: finished-config"

