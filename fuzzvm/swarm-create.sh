#!/bin/bash

#Script for swarm master setup

#TODO: Investigate if there can be timing issues.


BASTION_ADDRESS=$1
shift;

echo $BASTION_ADDRESS > $HOME/address_bastion

echo $@ > $HOME/address_nodes

MASTER_ADDRESS=$1
shift;
NODE_ADDRESSES=$@

scripts/setup-node.sh $MASTER_ADDRESS $MASTER_ADDRESS;

echo "Starting docker swarm discovery service."
docker run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap;

echo "Starting docker swarm manager container"
docker run -d -p 4000:4000 swarm manage -H :4000 --advertise $MASTER_ADDRESS:4000 consul://$MASTER_ADDRESS:8500;

echo "Setting up nodes."
for node in $NODE_ADDRESSES; do
	#Connect each swarm node and run node setup script.
	ssh -o StrictHostKeyChecking=no $node "scripts/setup-node.sh $node $MASTER_ADDRESS";
	scp -o StrictHostKeyChecking=no $HOME/address_bastion $node:;
done

echo "Swarm setup completed. Waiting 10s for status update."
#Print docker info
sleep 10;

NODES=$(cat address_nodes | wc -w)

WAITS=0;
while (( $NODES != $(docker -H :4000 info | awk '$1 == "Nodes:" {print $2}') )); do 
	echo "Nodes are not ready yet..."
	let WAITS++;
	if (( $WAITS == 6 )); then
		echo "For some reason nodes haven't come up yet. Aborting."
		exit;
	fi
	echo "Waiting another 10s."
	sleep 10;
done

echo "All nodes are online."