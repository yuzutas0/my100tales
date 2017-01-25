#!/bin/bash

# -----------------------
# install
# -----------------------

su

yum -y install redis

systemctl start redis
systemctl enable redis

systemctl status redis
# check: active

redis-cli -p 6379
# > ping
# check: PONG
