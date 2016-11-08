#!/bin/bash

#Sript to setup and attach a swarm node in to the swarm.

MASTER_ADDRESS=$1;
OWN_ADDRESS=$(hostname -I | awk '{print $1}');


echo "Setting up new node:"
echo "Swarm master IP: $MASTER_IP"
echo "Node to setup: $OWN_ADDRESS"



#Setup new systemd ExecStart parameters for docker service.
sudo systemctl stop docker;
sudo mkdir -p /etc/systemd/system/docker.service.d;
#New parameters open socket tcp://0.0.0.0:2375 for swarm manager
sudo mv $HOME/scripts/swarm-node-systemd.conf /etc/systemd/system/docker.service.d;

#Remove docker key.json that was generated during installation.
#All fuzzvms were cloned from same image, so all have the same ID
#which conflicts in docker swarm
sudo rm /etc/docker/key.json

#Reload new systemd parameters and restart docker daemon
sudo systemctl daemon-reload;
sudo systemctl restart docker;


#Note: We expect the discovery service to run at same machine as swarm master
docker run -d swarm join --advertise=$OWN_ADDRESS:2375 consul://$MASTER_ADDRESS:8500;



