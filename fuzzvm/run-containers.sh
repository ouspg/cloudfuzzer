#!/bin/bash

COUNT=$1

for instance in $(seq 1 $COUNT); do
	echo "Starting instance: $instance"
	docker -H :4000 run $(cat $HOME/docker-options);
done