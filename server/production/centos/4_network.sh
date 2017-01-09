#!/bin/bash

su

firewall-cmd --permanent --add-service=ssh --zone=public
firewall-cmd --reload
