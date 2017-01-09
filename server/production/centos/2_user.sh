#!/bin/bash

# ================================
# variables
# ================================
user=centos
password=$1
group=wheel

# ================================
# make wheel user
# ================================

useradd ${user}
passwd ${user}
# => ${password}

usermod -G ${group} ${user}

vi /etc/pam.d/su
# => auth   required   pam_wheel.so use_uid
