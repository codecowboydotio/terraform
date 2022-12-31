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
deb https://packages.nginx.org/unit/ubuntu/ jammy unit
deb-src https://packages.nginx.org/unit/ubuntu/ jammy unit
EOF
apt-update
apt install -y build-essential libcap2-bin net-tools jq
apt install -y nodejs npm
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
apt install -y golang-go
apt update
apt install -y php php-dev libphp-embed
apt update
curl -L https://go.dev/dl/go1.19.linux-amd64.tar.gz -o /tmp/go1.19.linux-amd64.tar.gz
tar -C /usr/local -xzf /tmp/go1.19.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin
echo "########################################################################################"
apt install -y unit
apt install -y unit-dev unit-go unit-jsc11 unit-perl unit-php unit-python2.7 unit-python3.10 unit-ruby
echo "########################################################################################"
sleep 30
systemctl start unit
mkdir -p /apps/status
chown unit:unit /apps
cat << EOF > /apps/status/index.html
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
                                "share": "/apps/status/"
                        }
                }
        ]
}' --unix-socket /var/run/control.unit.sock http://localhost/config/
apt install -y docker.io
echo "<p>installed docker runtime...</p>" >> /apps/status/index.html
#git clone https://github.com/codecowboydotio/dockerfiles
#echo "<p>cloned dockerfiles...</p>" >> /apps/status/index.html
#cd dockerfiles/swapi-json
#docker build . --tag=swapi
#echo "<p>built swapi-json container image...</p>" >> /apps/status/index.html
#docker run -d -p 3000:3000 swapi
#echo "<p>deployed container image...</p>" >> /apps/status/index.html
#git clone https://github.com/codecowboydotio/helloworld-java /apps/jsp
#echo "<p>cloned jsp...</p>" >> /apps/status/index.html
apt install -y nodejs npm
echo "<p>installed node and npm</p>" >> /apps/status/index.html
apt install -y ansible
echo "<p>Installed ansible</p>" >> /apps/status/index.html
#git clone http://github.com/codecowboydotio/swapi-vue /apps/swapi-vue
#echo "<p>Cloned swapi-vue</p>" >> /apps/status/index.html
#cd /apps/swapi-vue
#npm install -g @vue/cli
#echo "<p>installed vue cli</p>" >> /apps/status/index.html
#npm i @vue/cli-service
#echo "<p>installed cli service</p>" >> /apps/status/index.html
#sed -i 's/10.1.1.150/api.svkcode.org/g' /apps/swapi-vue/src/components/*.vue
systemctl stop apache2
echo "<p>stopped default apache server</p>" >> /apps/status/index.html
apt install -y python3-pip python3
pip install flask
pip install flasgger
pip install gitpython
echo "<p>Installed Unit GIT API pre-requisites</p>" >> /apps/status/index.html
#git clone http://github.com/codecowboydotio/git-pull-api /apps/git-pull-api
#echo "<p>Cloned Unit GIT API</p>" >> /apps/status/index.html
pkill unitd
MY_IP=$(ip -br addr | grep eth0 | awk '{print $3}' | awk -F"/" '{print $1}' | head -1)
unitd --modules /usr/lib/unit/modules --control 0.0.0.0:8888
cd /apps
#git clone http://github.com/codecowboydotio/go-rest-api
git clone -b rel-0.3 https://github.com/project-tetsuo/project-tetsuo
echo "<p>Cloned TETSUO</p>" >> /apps/status/index.html
cd /apps/project-tetsuo/go-rest-api
export GO111MODULE=on
rm -rf go.mod
sleep 5
go mod init go-rest-api
go mod tidy
pwd
id
whoami
export GOMODCACHE=/root/go
export HOME=/root/
echo "running go get"
go get
echo "running go build"
go build
echo "<p>built go api</p>" >> /apps/status/index.html
ls -la
curl -X PUT --data-binary '{
        "listeners": {
                "*:8080": {
                        "pass": "applications/tetsuo"
                },
                "*:8181": {
                        "pass": "applications/config-app"
                }
        },

        "applications": {
                "tetsuo": {
                        "type": "external",
                        "working_directory": "/apps/project-tetsuo/go-rest-api",
                        "executable": "/apps/project-tetsuo/go-rest-api/go-rest-api",
                        "environment": {
                                "version": "2.0",
                                "git_repo": "https://github.com/codecowboydotio/git-pull-api"
                        }
                },
		"config-app": {
                        "type": "python",
                        "path": "/apps/project-tetsuo/config-api",
                        "working_directory": "/apps/project-tetsuo/config-api",
                        "module": "wsgi",
                        "callable": "app"
                }
        }
}' http://$MY_IP:8888/config
echo "<p>Applied tetsuo config</p>" >> /apps/status/index.html
echo "<p>FINISHED</p>" >> /apps/status/index.html
echo "firstrun debug: finished-config"
