#!/bin/bash

# ================================
# variables
# ================================

# refs. [settings](./../centos/0_network.sh)
host_name=$1
domain_name=$2

# ================================
# install
# ================================

su

yum install postfix # unless postfix has already been installed.

# ================================
# set sender domain
# ================================

vim /etc/postfix/main.cf
# ------------------------------------------------------------------------------------------------------------
# from: #myhostname = virtual.domain.tld
#
# to:   #myhostname = virtual.domain.tld
#       myhostname = ${host_name}.${domain_name}
# ------------------------------------------------------------------------------------------------------------
# from: #mydomain = domain.tld
#
# to:   #mydomain = domain.tld
#       mydomain = ${domain_name}
# ------------------------------------------------------------------------------------------------------------
# from: #myorigin = $mydomain
# to:   myorigin = $mydomain
# ------------------------------------------------------------------------------------------------------------

# ================================
# enable SMTPS
# ================================

vim /etc/postfix/main.cf
# ------------------------------------------------------------------------------------------------------------
# from:
# to:   # Enable SMTP Auth
#       smtpd_sasl_auth_enable = yes
#       smtpd_sasl_security_options = noanonymous
#       broken_sasl_auth_clients = yes
#       smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
# ------------------------------------------------------------------------------------------------------------
