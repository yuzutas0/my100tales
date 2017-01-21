#!/bin/bash

# ================================
# variables
# ================================

key_name=$1
passphrase=$2
server_user=$3
server_ip=$4
server_password=$5
root_password=$6
ssh_port=$7 # 49152 - 65535

# ================================
# install OpenSSH
# ================================

su

yum -y install openssh openssh-clients openssh-server

systemctl restart sshd
systemctl enable sshd

slogin 127.0.0.1
# check whether login is success

exit
# from 127.0.0.1

exit
# from root

# ================================
# generate key (at local machine)
# ================================

ssh-keygen
# Enter file => ~/.ssh/${key_name}
# Enter passphrase => ${passphrase}
# Confirm passphrase => ${passphrase}

scp ~/.ssh/${key_name}.pub ${server_user}@${server_ip}:/home/${server_user}/

# ================================
# use key (at server)
# ================================

mkdir ~/.ssh/
chmod 700 ~/.ssh

touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

cat ~/${key_name}.pub >> ~/.ssh/authorized_keys

# ================================
# disable root & password
# ================================

su
# enter ${root_password}

vim /etc/ssh/sshd_config
# -----------------------------------------
# from: #Port 22
# to:   Port ${ssh_port}
# -----------------------------------------
# from: #Protocol 2
# to:   Protocol 2
# -----------------------------------------
# from: #LoginGraceTime 2m
# to:   LoginGraceTime 2m
# -----------------------------------------
# from: #PermitRootLogin yes
# to:   PermitRootLogin no
# -----------------------------------------
# from: #MaxAuthTries 6
# to:   MaxAuthTries 6
# -----------------------------------------
# from: #PubkeyAuthentication yes
# to:   PubkeyAuthentication yes
# -----------------------------------------
# from: PasswordAuthentication yes
# to:   PasswordAuthentication no
# -----------------------------------------

systemctl restart sshd

# ================================
# open port
# ================================

# if firewalld has already been started
firewall-cmd --permanent --zone=public --add-port=${ssh_port}/tcp
firewall-cmd --reload

# ================================
# block brute-force attack
# ================================

yum install fail2ban

cat /etc/fail2ban/jail.conf | grep ssh
# check weather "port=ssh" is found at /etc/fail2ban/jail.conf

touch /etc/fail2ban/jail.local

cat << _EOF > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1/8
bantime = 86400
findtime = 3600

[sshd]
enabled = true
port = ${ssh_port}
maxretry = 6

[sshd-ddos]
enabled = true
port = ${ssh_port}
maxretry = 6
_EOF

systemctl start fail2ban
systemctl enable fail2ban

# ================================
# test (at local machine)
# ================================

# login
ssh -i ~/.ssh/${key_name} -p ${ssh_port} ${server_user}@${server_ip}

# send file
scp -i ~/.ssh/${key_name} -p ${ssh_port} ~/example.txt ${server_user}@${server_ip}:/home/${server_user}/
