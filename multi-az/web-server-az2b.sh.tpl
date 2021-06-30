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
echo "firstrun debug: starting-config"
logger -p local0.info 'firstrun debug: starting--config'
dnf -y install httpd
dnf -y install unzip
dnf -y install net-tools
systemctl start httpd
git clone https://github.com/platzhersh/pacman-canvas /var/www/html/
mv /var/www/html/index.htm /var/www/html/index.html
sudo route add -net 0.0.0.0 gw ${default_route}
sudo route del -net 0.0.0.0 gw 10.200.6.1
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
