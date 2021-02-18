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
git clone https://github.com/platzhersh/pacman-canvas /var/www/html/
mv /var/www/html/index.htm /var/www/html/index.html
cp /tmp/nginx-hex.svg /var/www/html/img/blinky.svg
cp /tmp/nginx-hex.svg /var/www/html/img/clyde.svg
cp /tmp/nginx-hex.svg /var/www/html/img/inky.svg
cp /tmp/nginx-hex.svg /var/www/html/img/pinky.svg
sed '/^<\/head>/i ${device_id_script_tag}' /var/www/html/index.html > /tmp/fooble
mv /tmp/fooble /var/www/html/index.html
systemctl start httpd
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
