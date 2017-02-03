#!/bin/bash

set -o errexit
set -o nounset

#Stop fuzzing containers running on our cluster.

NODE_ADDRESSES=$(cat $HOME/address_nodes);
BASTION_ADDRESS=$(cat $HOME/address_bastion);
echo "Stopping containers:" 1>&2;
for node in $NODE_ADDRESSES; do
	echo $node 1>&2;
	for container in $(docker -H $node:2375 ps -a | sed -e "1d" | awk  '$2 != "swarm" && $2 != "nabeken/docker-volume-container-rsync" && $2 != "progrium/consul" {print $1}'); do
		echo $container 1>&2;
		docker -H $node:2375 stop $container;
	done
done