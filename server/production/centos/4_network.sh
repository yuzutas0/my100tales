#!/bin/bash

su

firewall-cmd --permanent --add-service=ssh --zone=public
firewall-cmd --reload

# ip (http/https, ssh, smtp*2)
# v6
