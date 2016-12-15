#!/bin/bash

set -o errexit
set -o nounset

#Usage: bash send-docker-data.sh <bastion-address> <directory-with-docker-data>
#Example: bash send-docker-data.sh ubuntu@bastion ./fuzz-data

#Requirements:
# fuzz-data directory must have the following structure:
#	fuzz-data:
#		docker-image
#		docker-options

#docker-image: 
#	docker image saved with: docker save <image> > docker-image

#docker-run-options: 
#	one liner docker run options. 
#	Is used in swarm manager: docker run $(cat docker-options)
BASTION=$1;
DIRECTORY=$2;

scp -o StrictHostKeyChecking=no -Cr $2/* $1:
ssh -o StrictHostKeyChecking=no $BASTION 'scripts/distribute-local-docker-image.sh ./docker-image'
