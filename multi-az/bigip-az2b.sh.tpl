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

function checkStatus() {
  count=1
  sleep 10;
  STATUS=`cat /var/prompt/ps1`;
  while [[ "$STATUS"x != 'Active'x ]]; do
    echo -n '.';
    sleep 5;
    count=$(($count+1));
    STATUS=`cat /var/prompt/ps1`;

    if [[ $count -eq 60 ]]; then
      checkretstatus=\"restart\";
      return;
    fi
  done;
  checkretstatus=\"run\";
}

function checkF5Ready {
  sleep 5
  while [[ ! -e '/var/prompt/ps1' ]]
  do
    echo -n '.'
    sleep 5
  done

  sleep 5
  STATUS=`cat /var/prompt/ps1`

  while [[ "$STATUS"x != 'NO LICENSE'x ]]
  do
    echo -n '.'
    sleep 5
    STATUS=`cat /var/prompt/ps1`
  done

  echo -n ' '

  while [[ ! -e '/var/prompt/cmiSyncStatus' ]]
  do
    echo -n '.'
    sleep 5
  done

  STATUS=`cat /var/prompt/cmiSyncStatus`
  while [[ "$STATUS"x != 'Standalone'x ]]
  do
    echo -n '.'
    sleep 5
    STATUS=`cat /var/prompt/cmiSyncStatus`
  done
}

function checkStatusnoret {
  sleep 10
  STATUS=`cat /var/prompt/ps1`
  while [[ "$STATUS"x != 'Active'x ]]
  do
    echo -n '.'
    sleep 5
    STATUS=`cat /var/prompt/ps1`
  done
}

exec 1<&-
exec 2<&-
exec 1<>$FILE
exec 2>&1
checkF5Ready
sleep 150
logger -p local0.info 'firstrun debug: starting-tmsh-config'
logger -p local0.info 'firstrun debug: setting policy'
tmsh modify /auth password-policy policy-enforcement disabled
tmsh modify auth user admin { password ${bigip_password} }
tmsh modify auth user admin shell bash
tmsh save /sys config
tmsh modify sys global-settings { gui-security-banner enabled gui-security-banner-text 'ADMIN PASSWORD HAS BEEN SET' }
logger -p local0.info 'firstrun debug: applying license'
SOAPLicenseClient  --basekey ${bigip_license}
checkStatusnoret
tmsh modify sys global-settings gui-setup disabled
tmsh modify /sys http auth-pam-validate-ip off
curl -L https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.29.0/f5-appsvcs-3.29.0-3.noarch.rpm -o f5-appsvcs-3.29.0-3.noarch.rpm
FN=f5-appsvcs-3.29.0-3.noarch.rpm
CREDS=admin:admin
IP="127.0.0.1"
LEN=$(wc -c $FN | awk 'NR==1{print $1}')
curl -kvu $CREDS https://$IP/mgmt/shared/file-transfer/uploads/$FN -H 'Content-Type: application/octet-stream' -H "Content-Range: 0-$((LEN - 1))/$LEN" -H "Content-Length: $LEN" -H 'Connection: keep-alive' --data-binary @$FN

DATA="{\"operation\":\"INSTALL\",\"packageFilePath\":\"/var/config/rest/downloads/$FN\"}"
curl -kvu $CREDS "https://$IP/mgmt/shared/iapp/package-management-tasks" -H "Origin: https://$IP" -H 'Content-Type: application/json;charset=UTF-8' --data $DATA

tmsh create /net vlan outside interfaces add { 1.1 }
tmsh create /net vlan inside interfaces add { 1.2 }
tmsh create /net self ${subnet_6}/24 vlan outside
tmsh create /net self ${subnet_7}/24 vlan inside
tmsh modify /net self ${subnet_6}/24 allow-service all
tmsh modify /net self ${subnet_7}/24 allow-service all
tmsh create ltm pool web-az2b monitor tcp members add { ${web_server-az2b}:80 { } }
tmsh create ltm pool ssh-az2b monitor tcp members add { ${web_server-az2b}:22 { } }
tmsh create /net route  0.0.0.0/0 gw 10.100.6.1
tmsh create ltm virtual az2b-virt destination 10.100.6.11:80 pool web-az2b ip-protocol tcp profiles add { http } source-address-translation { type automap }
tmsh create ltm virtual az2b-ssh destination 10.100.6.11:22 pool ssh-az2b ip-protocol tcp source-address-translation { type automap }
tmsh create ltm virtual gw-outbound destination 0.0.0.0:0 ip-protocol any source-address-translation { type automap }

tmsh modify sys global-settings { gui-security-banner enabled gui-security-banner-text 'AUTOMATIC CONFIGURATION IS COMPLETE' }
logger -p local0.info 'firstrun debug: finished-config'
