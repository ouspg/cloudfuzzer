#!/bin/bash

#Sript to setup and attach a swarm node in to the swarm.


OWN_ADDRESS=$1;

MASTER_ADDRESS=$2;


echo ""
echo "Setting up new node:"
echo "Swarm master address: $MASTER_ADDRESS"
echo "Node to setup: $OWN_ADDRESS"



#Setup new systemd ExecStart parameters for docker service.
echo "Setting up service."
sudo systemctl stop docker;
echo "Stopped."
sudo mkdir -p /etc/systemd/system/docker.service.d;
#New parameters open socket tcp://0.0.0.0:2375 for swarm manager
sudo mv $HOME/scripts/swarm-node-systemd.conf /etc/systemd/system/docker.service.d;
echo "Configuration replaced."
#Remove docker key.json that was generated during installation.
#All fuzzvms were cloned from same image, so all have the same ID
#which conflicts in docker swarm
sudo rm /etc/docker/key.json

#Reload new systemd parameters and restart docker daemon
sudo systemctl daemon-reload;
sudo systemctl restart docker;
echo "Service restarted."

#Note: We expect the discovery service to run at same machine as swarm master
echo "Running swarm node container."
docker run -d swarm join --advertise=$OWN_ADDRESS:2375 consul://$MASTER_ADDRESS:8500;
echo "All done."


