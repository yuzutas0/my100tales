#!/bin/bash

# ================================
# disable SELinux
# ================================

setenforce 0

getenforce
# check: Permissive

vim /etc/sysconfig/selinux
# from: SELINUX=enforcing
# to:   SELINUX=disabled

# login count
