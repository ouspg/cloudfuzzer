#!/bin/bash

#Collects results to bastion.

#Usage: bastion:~$ ssh $(cat address_master) "collect-results.sh" | tar x

NODE_ADDRESSES=$(cat $HOME/address_nodes);
#echo "Setting up nodes."
for node in $NODE_ADDRESSES; do
#	echo $node;
	for container in $(docker -H $node:2375 ps -a | sed -e "1d" | awk  '$2 != "swarm" && $2 != "progrium/consul" {print $1}'); do
#		echo $container;
		docker -H $node:2375 cp $container:/results -;
	done
done