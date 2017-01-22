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
