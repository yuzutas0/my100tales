#!/bin/bash

# ================================
# variables
# ================================

key_name=$1
passphrase=$2
server_user=$3
server_ip=$4
ssh_port=$5

# ================================
# install OpenSSH
# ================================

su

yum install openssh openssh-clients openssh-server

systemctl restart sshd.service
systemctl enable sshd.service

slogin 127.0.0.1
# Check whether login is success

exit

# ================================
# generate key (at local machine)
# ================================

ssh-keygen
# Enter file => ~/.ssh/${key_name}
# Enter passphrase => ${passphrase}
# Confirm passphrase => ${passphrase}

scp ~/.ssh/${key_name}.pub ${server_user}@${server_ip}

slogin ${server_user}@${server_ip}

# ================================
# use key (at server)
# ================================

touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
cat ~/${key_name}.pub >> ~/.ssh/authorized_keys

# ================================
# disable root & password
# ================================

su

vim /etc/ssh/sshd_config
# --------------------------------
# from: #PermitRootLogin yes
# to:   PermitRootLogin no
# --------------------------------
# from: PasswordAuthentication yes
# to:   PasswordAuthentication no
# --------------------------------

systemctl restart sshd.service

# ================================
# block brute-force attack
# ================================

yum install fail2ban

# check weather "port=ssh" is found at /etc/fail2ban/jail.conf

cat << _EOF /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1/8
bantime = 86400
findtime = 3600

[sshd]
enabled = true
maxretry = 3
_EOF

systemctl start fail2ban
systemctl enable fail2ban

# ================================
# the way to login
# ================================

ssh -i ~/.ssh/${key_name} -p ${ssh_port} ${server_user}@${server_ip}
