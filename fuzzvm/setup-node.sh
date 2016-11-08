#!/bin/bash

#Sript to setup and attach a swarm node in to the swarm.

MASTER_ADDRESS=$1;
OWN_ADDRESS=$(hostname -I | awk '{print $1}');


echo "Setting up new node:"
echo "Swarm master IP: $MASTER_IP"
echo "Node to setup: $OWN_ADDRESS"


#Note: We expect the discovery service to run at same machine as swarm master
mkdir -p /etc/systemd/system/docker.service.d;
mv $HOME/scripts/swarm-node-systemd.conf /etc/systemd/system/docker.service.d;

sudo systemctl daemon-reload;
sudo systemctl restart docker;

docker run -d swarm join --advertise=$OWN_ADDRESS:2375 consul://$MASTER_ADDRESS:8500;



