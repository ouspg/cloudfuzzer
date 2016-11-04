#!/bin/bash

#Sript to setup and attach a swarm node in to the swarm.

MASTER_ADDRESS=$1;
NODE_ADDRESS=$2;


echo "Setting up new node:"
echo "Swarm master IP: $MASTER_IP"
echo "Node to setup: $NODE_ADDRESS"


#Note: We expect the discovery service to run at same machine as swarm master

#TODO: Find a way to do this automatically

#
#sudo pkill -9 docker
#sudo docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &
#docker run -d swarm join --advertise=$NODE_ADDRESS:2375 consul://$MASTER_ADDRESS:8500


#The following way did not work... DOCKER_OPTS are not loaded.
#ssh $NODE_ADDRESS 'echo "DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock\"" | sudo tee /etc/default/docker;';
#ssh $NODE_ADDRESS 'sudo pkill -9 docker; sudo service docker restart;';
#ssh $NODE_ADDRESS "docker run -d swarm join --advertise=$NODE_ADDRESS:2375 consul://$MASTER_ADDRESS:8500;";

