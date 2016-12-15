#!/bin/bash

set -o errexit
set -o nounset

#Collects results to bastion.

#Usage: bastion:~$ ssh $(cat address_master) "collect-results.sh" | tar x

NODE_ADDRESSES=$(cat $HOME/address_nodes);
BASTION_ADDRESS=$(cat $HOME/address_bastion);
echo "Getting results." 1>&2;
for node in $NODE_ADDRESSES; do
	echo $node 1>&2;
	for container in $(docker -H $node:2375 ps -a | sed -e "1d" | awk  '$2 != "swarm" && $2 != "progrium/consul" {print $1}'); do
		echo $container 1>&2;
		docker -H $node:2375 cp $container:/results - | gzip |\
		ssh -o StrictHostKeyChecking=no $BASTION_ADDRESS 'mkdir -p $HOME/results/'$container' && tar --strip-components=1 --skip-old-files -xzf - -C $HOME/results/'$container;
	done
done