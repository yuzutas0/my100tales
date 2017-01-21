#!/bin/bash

# Set host & domain name at your server

# ================================
# variables
# ================================

# look at mail from hosting service
server_ip=$1
root_password=$2

# as you like
os_user=$3
os_password=$4

# ================================
# first login
# ================================

ssh root@${server_ip}
# Enter ${root_password}

# ================================
# make wheel user
# ================================

useradd ${os_user}

passwd ${os_user}
# set ${os_password}
# confirm ${os_password}

usermod -G wheel ${os_user}

vi /etc/pam.d/su
# from: #auth   required   pam_wheel.so use_uid
# to:   auth   required   pam_wheel.so use_uid

# ================================
# check
# ================================

cat /etc/passwd
cat /etc/group
getent group wheel
