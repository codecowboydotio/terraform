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
dnf -y install httpd
dnf -y install unzip
dnf -y install net-tools
dnf -y install ansible
systemctl start httpd
git clone https://github.com/platzhersh/pacman-canvas /var/www/html/
mv /var/www/html/index.htm /var/www/html/index.html
git clone https://github.com/codecowboydotio/ansible 
ansible-playbook /ansible/telegraf.yml -e 'target_hosts=localhost beacon_access_token=${beacon_access_token}'
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
