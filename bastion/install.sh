#!/bin/bash

set -o errexit
set -o nounset

##
##Bastion install script.
##

mkdir -p $HOME/.ssh;
mv /tmp/bastion-key $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa
cat /tmp/bastion-key.pub >> $HOME/.ssh/authorized_keys
cat /tmp/fuzzvm-key.pub >> $HOME/.ssh/authorized_keys

mv /tmp/scripts $HOME/

sudo passwd ubuntu -l
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

