#!/bin/bash

#Script for swarm master setup

#TODO: Investigate if there can be timing issues.

NODE_ADDRESSES=$@

MASTER_ADDRESS=$(hostname -I | awk '{print $1}');

docker run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap;

sleep 5;

docker run -d -p 4000:4000 swarm manage -H :4000 --advertise $MASTER_ADDRESS:4000 consul://$MASTER_ADDRESS:8500;

for node in $NODE_ADDRESSES; do
	#TODO: Setup swarm-nodes, it might be easier to run this on remote.
	ssh $node "scripts/setup-node.sh $MASTER_ADDRESS";
done