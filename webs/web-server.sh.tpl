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
dnf -y install httpd
dnf -y install unzip
dnf -y install net-tools
git clone https://github.com/platzhersh/pacman-canvas /var/www/html/
mv /var/www/html/index.htm /var/www/html/index.html
systemctl start httpd
dnf -y install java-11-openjdk java-11-openjdk-devel
echo "firstrun debug: finished-config"
wget https://downloads.apache.org/tomcat/tomcat-10/v10.0.12/bin/apache-tomcat-10.0.12-fulldocs.tar.gz
logger -p local0.info 'firstrun debug: finished-config'
