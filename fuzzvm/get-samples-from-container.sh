#!/bin/bash

set -o errexit
set -o nounset

#Collect diff of samples from container

#Usage via bastion:~$ scripts/collect-samples.sh

CONTAINER=$1

docker diff $CONTAINER | awk '$1 == "A" && $2 ~ /samples/ {print $2}' | docker exec -i $CONTAINER tar -xc -T -