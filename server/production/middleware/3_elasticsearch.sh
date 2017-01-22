#!/bin/bash

# -----------------------
# install java
# -----------------------

su

yum -y install java-1.8.0-openjdk-headless

java -version
# check: java command is enabled

# -----------------------
# install elasticsearch
# -----------------------
# refs. https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

cat << _EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=http://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
_EOF

yum -y install elasticsearch

systemctl daemon-reload
systemctl start elasticsearch
systemctl enable elasticsearch

systemctl status elasticsearch
# check: active

# -----------------------
# install plugin
# -----------------------

cd /usr/share/elasticsearch
./bin/plugin install analysis-kuromoji
systemctl restart elasticsearch

yum -y install jq
curl -X GET 'http://localhost:9200/_nodes/plugins' | jq
# check: "plugins": [{"name": "analysis-kuromoji"
