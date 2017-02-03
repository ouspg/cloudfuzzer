#!/bin/bash

set -o errexit
set -o nounset

##
##FuzzVM install script.
##
##Note: This script is for Ubuntu 16.04

sudo apt-get update;
sudo apt-get install docker.io -y;

sudo groupadd -f docker
sudo gpasswd -a ${USER} docker
sudo service docker restart

sudo docker pull swarm;
sudo docker pull ubuntu;
sudo docker pull progrium/consul;
sudo docker pull nabeken/docker-volume-container-rsync;

mkdir -p $HOME/.ssh;
mv /tmp/fuzzvm-key $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa
cat /tmp/bastion-key.pub >> $HOME/.ssh/authorized_keys
cat /tmp/fuzzvm-key.pub >> $HOME/.ssh/authorized_keys

mv /tmp/scripts $HOME/

chmod +x $HOME/scripts/*

sudo passwd ubuntu -l
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
