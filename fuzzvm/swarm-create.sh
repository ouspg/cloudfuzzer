#!/bin/bash

#Script for swarm master setup


#TODO: Investigate if there can be timing issues.

IP_ADDR=$(hostname -I | awk '{print $1}');

docker run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap;

sleep 5;

docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise $IP_ADDR:4000 consul://$IP_ADDR:8500;

for node in $(cat ./nodes); do
	#TODO: Setup swarm-nodes, it might be easier to run this on remote.
	bash ./setup-node.sh $IP_ADDR $node;
done