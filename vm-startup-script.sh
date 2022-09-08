#!/bin/sh -x

apt update
apt upgrade -y
apt install -y ansible
mkdir /setup
cd /setup

#clone VM config source code
#run Ansible playbooks

date > /tmp/startup-script-finish
