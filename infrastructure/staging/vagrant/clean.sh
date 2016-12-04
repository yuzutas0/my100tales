#!/bin/bash

echo "------------------"
echo "vagrant destroy -f"
echo "------------------"

vagrant destroy -f

echo "--------------------------------------------"
echo "remove files about vagrant in this directory"
echo "--------------------------------------------"

rm Vagrantfile
rm -rf .vagrant

echo ""
echo "finish"
echo ""

echo "-------------------------------------------------------------------------------"
echo "*** Attention ***"
echo "-------------------------------------------------------------------------------"
echo "*** 1) you should delete staging.my100tales.com settings from ~/.ssh/config ***"
echo "*** 2) you should delete staging.my100tales.com settings from /etc/hosts"
echo "-------------------------------------------------------------------------------"
