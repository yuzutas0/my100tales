#!/bin/bash

# ================================
# variables
# ================================

app_name=$1

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
# settings
# -----------------------

sed -i '$a cluster.name: ${app_name}' /etc/elasticsearch/elasticsearch.yml
sed -i '$a node.name: ${HOSTNAME}' /etc/elasticsearch/elasticsearch.yml

curl http://localhost:9200/_nodes/process?pretty
# check: "mlockall" = false
ps -aef | grep elasticsearch | grep -v grep
# check: -Xms256m -Xmx1g
free
# check: Mem x total
# calculate: Math.min((Mem x total / 2), 32GB) => ${memory}
#   e.g. 256m, 1g
sed -i '$a ES_HEAP_SIZE=${memory}' /etc/sysconfig/elasticsearch
sed -i '$a MAX_LOCKED_MEMORY=unlimited' /etc/sysconfig/elasticsearch
sed -i '$a bootstrap.memory_lock: true' /etc/elasticsearch/elasticsearch.yml

mkdir /etc/systemd/system/elasticsearch.service.d/
cat << _EOF > /etc/systemd/system/elasticsearch.service.d/limit.conf
[Service]
LimitMEMLOCK=infinity
_EOF
systemctl daemon-reload

systemctl restart elasticsearch
systemctl status elasticsearch

curl http://localhost:9200/_nodes/process?pretty
# check: cluster_name, node_name, memory_lock
ps -aef | grep elasticsearch | grep -v grep
# check: -Xms${memory} -Xmx${memory}

# -----------------------
# install plugin
# -----------------------

cd /usr/share/elasticsearch
./bin/plugin install analysis-kuromoji
systemctl restart elasticsearch

yum -y install jq
curl -X GET 'http://localhost:9200/_nodes/plugins' | jq
# check: "plugins": [{"name": "analysis-kuromoji"
