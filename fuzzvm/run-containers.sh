#!/bin/bash

COUNT=$1

if [ -z $COUNT ]; then
	COUNT=1;
fi

DOCKER_COMMAND="docker service create --name fuzz-service --replicas $COUNT \
	--mount type=volume,source=rsync-volume-container,destination=/output \
	$(cat $HOME/docker-options);"

echo "Starting fuzz-service:"
echo "Instances: $COUNT"
echo "Full command:"
echo "$DOCKER_COMMAND"

bash -c "$DOCKER_COMMAND";


