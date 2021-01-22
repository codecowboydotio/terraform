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
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get update
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo apt-get install elasticsearch
echo "network.host: \"localhost\"" >> /etc/elasticsearch/elasticsearch.yml
echo "http.port: 9200" >> /etc/elasticsearch/elasticsearch.yml
#dev mode
echo "discovery.type: single-node" >> /etc/elasticsearch/elasticsearch.yml
# prod mode
#echo "cluster.initial_master_nodes: ["<PrivateIP"]" >> /etc/elasticsearch/elasticsearch.yml
service elasticsearch start

#install logstash
echo "begin installing logstash"
logger -p local0.info 'begin installing logstash'
sudo apt-get install default-jre
sudo apt-get install logstash
sudo apt-get install kibana
echo "server.port: 5601" >> /etc/kibana/kibana.yml
#echo "elasticsearch.url: "http://localhost:9200"" >> /etc/kibana/kibana.yml
echo "elasticsearch.hosts: [\"http://localhost:9200\"]" >> /etc/kibana/kibana.yml
echo "server.host: \"0.0.0.0\"" >> /etc/kibana/kibana.yml
service kibana start
cat << EOF > /etc/logstash/conf.d/logstash-syslog.conf
input {
  tcp {
    port => 5000
    type => syslog
  }
  udp {
    port => 5000
    type => syslog
  }
}

filter {
  grok {
    match => {
      "message" => "(\"%%{DATA:f5_cgnat_type}\")?\"%%{DATA:f5_cgnat_client_src}:%%{DATA:f5_cgnat_client_port}\"\"%%{DATA:f5_cgnat_proto}\"\"%%{DATA:f5_cgnat_outbound_ip}:%%{DATA:f5_cgnat_outbound_port}\""
    }
  }
}

output {
  elasticsearch { hosts => ["localhost:9200"] }
  stdout { codec => rubydebug }
}
EOF
systemctl start logstash
echo "firstrun debug: finished-config"
logger -p local0.info 'firstrun debug: finished-config'
