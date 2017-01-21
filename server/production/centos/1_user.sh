#!/bin/bash

# Set host & domain name at your server

# ================================
# variables
# ================================

# look at mail from hosting service
server_ip=$1
origin_password=$2

# as you like
user=$3
password=$4
group=wheel

# ================================
# first login
# ================================

ssh root@${server_ip}
# Enter ${origin_password}

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
