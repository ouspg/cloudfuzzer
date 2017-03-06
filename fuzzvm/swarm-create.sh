#!/bin/bash

#Script for swarm master setup

#TODO: Investigate if there can be timing issues.

BASTION_ADDRESS=$(cat $HOME/address_bastion);
MASTER_ADDRESS=$(cat $HOME/address_master);
NODE_ADDRESSES=$(cat $HOME/address_nodes);


docker swarm init --advertise-addr $MASTER_ADDRESS 1> /dev/null;

WORKER_TOKEN=$(docker swarm join-token worker -q)

echo "Setting up nodes."
for node in $NODE_ADDRESSES; do
	if [ $node == $MASTER_ADDRESS ]; then
		continue
	fi
	#Connect each swarm node and run swarm join script.
	scp -o StrictHostKeyChecking=no $HOME/address_* $node:;
	ssh -o StrictHostKeyChecking=no $node "docker swarm join --token $WORKER_TOKEN $MASTER_ADDRESS:2377";
done

echo "Starting rsync-volume-containers."
docker  service create --mode global --publish mode=host,target=873,published=10873 --name rsync-volume-container \
		--mount type=volume,source=rsync-volume-container,destination=/output   \
		-e VOLUME=/output -e ALLOW="$BASTION_ADDRESS" nabeken/docker-volume-container-rsync;

echo "Swarm setup completed. Waiting for rsync-volume-container to be started on all nodes."
sleep 10;

NODE_COUNT=$(echo $NODE_ADDRESSES | wc -w)

WAITS=0;
while (( $NODE_COUNT != $(docker service ps rsync-volume-container | grep 'Running\s\+Running' | wc -l) )); do
	echo "Nodes are not ready yet..."
	let WAITS++;
	if (( $WAITS == 12 )); then
		echo "For some reason rsync-volume-containers haven't come up yet. Aborting."
		exit;
	fi
	echo "Waiting another 10s."
	sleep 10;
done

echo "All nodes are ready."
