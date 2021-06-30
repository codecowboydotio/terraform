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
sleep 50
echo "firstrun debug: starting-config"
logger -p local0.info 'firstrun debug: starting--config'
dnf -y install ansible
dnf -y install unzip
dnf -y install net-tools
ansible-galaxy collection install f5networks.f5_modules
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
