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
# set ${password}
# confirm ${password}

usermod -G ${group} ${user}

vi /etc/pam.d/su
# from: #auth   required   pam_wheel.so use_uid
# to:   auth   required   pam_wheel.so use_uid
