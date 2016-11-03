#!/bin/bash

##
##FuzzVM install script.
##

sudo apt-get update;
sudo apt-get install docker.io -y;

sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart


# docker-machine
sudo sh -c "curl -L https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine"

sudo docker pull swarm;
sudo docker pull ubuntu;
sudo docker pull progrium/consul;


#Quick hack to get past docker-machine apt-get update
sudo ln -s /bin/true /usr/local/bin/apt-get


mkdir -p $HOME/.ssh;
mv /tmp/fuzzvm-key $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa
cat /tmp/bastion-key.pub >> $HOME/.ssh/authorized_keys
cat /tmp/fuzzvm-key.pub >> $HOME/.ssh/authorized_keys
