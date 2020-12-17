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
sudo apt-get update
sudo apt-get -y install apt-transport-https
sudo apt-get update
sudo apt-get -y install ansible
sudo apt-get -y install python-pip
pip install f5-sdk

echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
