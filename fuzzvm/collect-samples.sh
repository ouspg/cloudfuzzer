#!/bin/bash

set -o errexit
set -o nounset

#Collects results to bastion.

#Usage: bastion:~$ ssh $(cat address_master) "collect-results.sh" | tar x

NODE_ADDRESSES=$(cat $HOME/address_nodes);
#echo "Getting samples."
for node in $NODE_ADDRESSES; do
	#echo $node;
	for container in $(docker -H $node:2375 ps -a | sed -e "1d" | awk  '$2 != "swarm" && $2 != "progrium/consul" {print $1}'); do
		#echo $container;
		ssh $node "scripts/get-samples-from-container.sh $container"
	done
done
