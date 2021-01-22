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
echo "starting first run"
cat << EOF > /etc/netplan/50-cloud-init.yaml
network:
    ethernets:
        eth0:
            dhcp4: false
            addresses: [${ip_address}/24]
            gateway4: ${gateway}
    version: 2
EOF
rm /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf
netplan apply
echo "finished first run"
