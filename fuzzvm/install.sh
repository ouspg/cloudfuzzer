#!/bin/bash

##
##FuzzVM install script.
##

sudo apt-get update;
sudo apt-get install docker.io -y;

# docker-machine
sudo sh -c "curl -L https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine"

mkdir -p $HOME/.ssh;
mv /tmp/fuzzvm-key $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa
cat /tmp/bastion-key.pub >> $HOME/.ssh/authorized_keys
cat /tmp/fuzzvm-key.pub >> $HOME/.ssh/authorized_keys
