#!/bin/bash

# todo: set host & domain name


# ================================
# variables
# ================================

# look at mail from hosting service
server_ip=$1
origin_password=$2

# ================================
# first login
# ================================

ssh root@${server_ip}
# Enter ${origin_password}
