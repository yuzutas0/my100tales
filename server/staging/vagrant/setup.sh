#!/bin/bash

echo "------------"
echo "vagrant init";
echo "------------"

vagrant init centos/7;

echo "----------"
echo "vagrant up"
echo "----------"

vagrant up --provider virtualbox;

echo "--------------"
echo "vagrant status"
echo "--------------"

vagrant status;

echo "-----------------------------------------------------------------"
echo "vagrant ssh-config --host staging.my100tales.com >> ~/.ssh/config"
echo "-----------------------------------------------------------------"

echo "# Vagrant by my100tales staging environment" >> ~/.ssh/config
vagrant ssh-config --host staging.my100tales.com >> ~/.ssh/config
vagrant ssh-config --host staging.my100tales.com

echo "------------"
echo "vagrant halt"
echo "------------"

vagrant halt;

echo "--------------"
echo "vagrant status"
echo "--------------"

vagrant status;

echo "------------------------------------------------"
echo "[TODO] 1) check the settings about ~/.ssh/config"
echo "------------------------------------------------"

echo "------------------------------------------------"
echo "[TODO] 2) set the routing to /etc/hosts"
echo "    - example:  127.0.0.1 staging.my100tales.com"
echo "------------------------------------------------"
