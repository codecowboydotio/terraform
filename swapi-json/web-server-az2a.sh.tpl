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
apt update
apt install -y docker.io
git clone https://github.com/codecowboydotio/dockerfiles
cd dockerfiles/swapi-json
docker build . --tag=swapi
docker run -d -p 80:3000 swapi
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
