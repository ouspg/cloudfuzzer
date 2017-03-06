#!/bin/bash

set -o errexit
set -o nounset

source $CLOUDFUZZER_DIR/scripts/functions.bash.inc

#Usage: bash send-docker-data.sh <directory-with-docker-data>
#Example: bash send-docker-data.sh ./fuzz-data

#Requirements:
# docker-data-directory must have the following structure:
#	docker-data-directory:
#		docker-image
#		docker-arguments

#docker-image:
#	docker image saved with: docker save <image> | gzip > docker-image

#docker-arguments:
#	docker run options: docker run <arguments>
#	

if [ -z "$1" ]; then
	echo "Missing required argument."
	echo "You must specify the docker-data-directory."
	return 1
fi 

DIRECTORY="$1";

if [ ! -f "$DIRECTORY/docker-arguments" ]; then
	echo "docker-arguments: No such file."
	echo "docker-arguments file should contain arguments that are given to docker run"
	echo "docker run <argument-to-run-fuzzer>"
	return 1
elif [ ! -f "$DIRECTORY/docker-image" ]; then
	echo "docker-image: No such file."
	echo "To save the image, you can use: docker save <image> | gzip > docker-image"
	return 1
fi

scp -o StrictHostKeyChecking=no -o User=$BASTION_USER -Cr $DIRECTORY/* $BASTION_ADDRESS:
ssh -o StrictHostKeyChecking=no -o User=$BASTION_USER $BASTION_ADDRESS 'scripts/helpers.sh distribute-docker-image ./docker-image'
