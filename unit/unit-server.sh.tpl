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
curl -sL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
cat << EOF >  /etc/apt/sources.list.d/unit.list
deb https://packages.nginx.org/unit/ubuntu/ groovy unit
deb-src https://packages.nginx.org/unit/ubuntu/ groovy unit
EOF
apt-update
apt install -y build-essential
apt install -y nodejs npm
apt install -y golang
curl -sL https://deb.nodesource.com/setup_X.Y | sudo bash -
apt install -y nodejs
npm install -g node-gyp
apt install -y php-dev libphp-embed
apt install -y libperl-dev
apt install -y python-dev
apt install -y ruby-dev
apt install -y openjdk-X-jdk
apt install -y libssl-dev
apt install -y libpcre2-dev
apt install -y libpcre3-dev
apt update
apt install -y php php-dev libphp-embed
apt update
apt install -y unit
apt install -y unit-dev unit-go unit-jsc11 unit-jsc13 unit-jsc14 unit-perl unit-php unit-python2.7 unit-python3.8 unit-ruby
apt install -y unit-dev unit-python2.7 unit-python3.8 
systemctl start unit
mkdir -p /www/status
chown unit:unit /www
cat << EOF > /www/status/index.html
<HTML>
<head>
  <meta http-equiv="refresh" content="10">
</head> 
<body>
<p>Unit Installed</p>
EOF
curl -X PUT --data-binary '{
        "listeners": {
                "*:8080": {
                        "pass": "routes"
                }
        },

        "routes": [
                {
                        "action": {
                                "share": "/www/status/"
                        }
                }
        ]
}' --unix-socket /var/run/control.unit.sock http://localhost/config/
apt install -y docker.io
echo "<p>installed docker runtime...</p>" >> /www/status/index.html
git clone https://github.com/codecowboydotio/dockerfiles
echo "<p>cloned dockerfiles...</p>" >> /www/status/index.html
cd dockerfiles/swapi-json
docker build . --tag=swapi
echo "<p>built swapi-json container image...</p>" >> /www/status/index.html
docker run -d -p 3000:3000 swapi
echo "<p>deployed container image...</p>" >> /www/status/index.html
git clone https://github.com/codecowboydotio/helloworld-java /www/jsp
echo "<p>cloned jsp...</p>" >> /www/status/index.html
apt install -y nodejs npm
echo "<p>installed node and npm</p>" >> /www/status/index.html
apt install -y ansible
echo "<p>Installed ansible</p>" >> /www/status/index.html
git clone http://github.com/codecowboydotio/swapi-vue /www/swapi-vue
echo "<p>Cloned swapi-vue</p>" >> /www/status/index.html
cd /www/swapi-vue
npm install -g @vue/cli
echo "<p>installed vue cli</p>" >> /www/status/index.html
npm i @vue/cli-service
echo "<p>installed cli service</p>" >> /www/status/index.html
sed -i 's/10.1.1.150/api.svkcode.org/g' /www/swapi-vue/src/components/*.vue
systemctl stop apache2
echo "<p>stopped default apache server</p>" >> /www/status/index.html
apt install -y pip python
pip install flask
pip install flasgger
pip install gitpython
echo "<p>Installed Unit GIT API pre-requisites</p>" >> /www/status/index.html
git clone http://github.com/codecowboydotio/git-pull-api /www/git-pull-api
echo "<p>Cloned Unit GIT API</p>" >> /www/status/index.html
echo "<p>FINISHED</p>" >> /www/status/index.html
pkill unitd
MY_IP=$(ip -br addr | grep eth0 | awk '{print $3}' | awk -F"/" '{print $1}' | head -1)
unitd --modules /usr/lib/unit/modules --control $MY_IP:8888
curl -X PUT --data-binary '{
        "listeners": {
                "*:8080": {
                        "pass": "applications/python"
                },
                "*:80": {
                        "pass": "routes"
                }
        },

        "routes": [
                {
                     "action": {
                         "share": "/www/pacman-unit/"
                        }
                }
        ],


        "applications": {
                "python": {
                        "type": "python",
                        "path": "/www/git-pull-api/",
                        "module": "wsgi",
                        "callable": "app",
                        "environment": {
                                "version": "2.0",
                                "git_repo": "https://github.com/codecowboydotio/git-pull-api"
                        }
                }
        }
}' http://$MY_IP:8888/config

echo "firstrun debug: finished-config"
