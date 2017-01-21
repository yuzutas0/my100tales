#!/bin/bash

# set host & domain name at your server

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
# enter ${root_password}

# ================================
# make wheel user
# ================================

useradd ${os_user}

passwd ${os_user}
# set ${os_password}
# confirm ${os_password}

usermod -G wheel ${os_user}

vi /etc/pam.d/su
# from: #auth  required   pam_wheel.so use_uid
# to:   auth   required   pam_wheel.so use_uid

# ================================
# check
# ================================

cat /etc/passwd
# find ${os_user}

cat /etc/group
# find ${os_user}, wheel

getent group wheel
# find ${os_user}

# ================================
# change user
# ================================

su ${os_user}

sudo echo hello
# enter ${os_password}

exit
# from ${os_user}

exit
# from remote server

ssh ${os_user}@${server_ip}
# enter ${os_password}
