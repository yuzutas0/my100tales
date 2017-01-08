#!/bin/bash

# refs. https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

vi /etc/yum.repos.d/elasticsearch.repo

# [elasticsearch-2.x]
# name=Elasticsearch repository for 2.x packages
# baseurl=http://packages.elastic.co/elasticsearch/2.3.5/centos
# gpgcheck=1
# gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
# enabled=1

yum install elasticsearch

systemctl start elasticsearch.service
systemctl enable elasticsearch.service

cd /usr/share/elasticsearch
sudo bin/plugin install analysis-kuromoji
