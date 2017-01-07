#!/bin/bash

# ================================
# make wheel user
# ================================

useradd centos
passwd centos
# => set password

usermod -G wheel centos

vi /etc/pam.d/su
# => auth   required   pam_wheel.so use_uid
