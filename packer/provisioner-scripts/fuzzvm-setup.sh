#!/bin/bash

set -o errexit
set -o nounset

##
##FuzzVM install script.
##
##Note: This script is for Ubuntu 16.04

sudo apt-get update;
sudo apt-get upgrade -y;

#Disable apport
sudo systemctl disable apport.service

#For afl support change fuzzvm core_pattern, 
#the default pattern triggers apport, which we disable by default.
echo "core" | sudo tee /proc/sys/kernel/core_pattern

#Add bastion and fuzzvm keys to authorized keys
mkdir -p $HOME/.ssh;
mv /tmp/fuzzvm-key $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa
cat /tmp/bastion-key.pub >> $HOME/.ssh/authorized_keys
cat /tmp/fuzzvm-key.pub >> $HOME/.ssh/authorized_keys

#CloudFuzzer uses docker functionality that requires newer docker than what is available at Ubuntu apt repos.
wget https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_17.03.0~ce-0~ubuntu-xenial_amd64.deb && \
sudo dpkg  --install docker-engine_17.03.0~ce-0~ubuntu-xenial_amd64.deb && rm docker-engine_17.03.0~ce-0~ubuntu-xenial_amd64.deb
sudo apt-get -f install -y 

#Add user to docker group
sudo groupadd -f docker
sudo gpasswd -a ${USER} docker

#In docker-engine 17.03, some of the docker service functionality is only available
#in experimental daemon mode, so we need to enable it until those features
#land stable.
sudo sh -c 'echo "{\"experimental\":true}" > /etc/docker/daemon.json'

sudo systemctl restart docker;

sudo docker pull nabeken/docker-volume-container-rsync;

sudo systemctl stop docker;

#Remove docker key.json. This forces docker to regenerate
#ID when the fuzzvm is started, otherwise multiple daemons
#with same ID will cause conflict in docker swarm. 
sudo rm /etc/docker/key.json

#Add fuzzvm scripts
mv /tmp/scripts $HOME/
chmod +x $HOME/scripts/*

#Remove passwd and disable ssh passwd login.
sudo passwd ubuntu -l
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
