#!/bin/bash

#Script for swarm master setup

#TODO: Investigate if there can be timing issues.


MASTER_ADDRESS=$1

NODE_ADDRESSES=$@

echo "Starting docker swarm discovery service."
docker run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap;

sleep 5;

echo "Starting docker swarm manager container"
docker run -d -p 4000:4000 swarm manage -H :4000 --advertise $MASTER_ADDRESS:4000 consul://$MASTER_ADDRESS:8500;

echo "Setting up nodes."
for node in $NODE_ADDRESSES; do
	#Connect each swarm node and run node setup script.
	ssh -o StrictHostKeyChecking=no $node "scripts/setup-node.sh $node $MASTER_ADDRESS";
done

echo "Swarm setup completed."
#Print docker info
docker -H :4000 info